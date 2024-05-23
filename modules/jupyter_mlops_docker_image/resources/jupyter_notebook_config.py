"""Vertex Workbench. Jupyter Service configuration file."""

import datetime
import logging
import os
import subprocess
import sys

from jupyter_client import kernelspec
import requests
from requests.adapters import HTTPAdapter

c.ServerProxy.servers = {}
if os.getenv('MLFLOW_ENABLED', 'false') == 'true':
  c.ServerProxy.servers['mlflow'] = {
    'command': ['/bin/bash', '-c', '/opt/tools/bin/start-mlflow.sh', '{port}'],
    'port': 5000,
    'absolute_url': False,
    'timeout': 30,
    'launcher_entry': {
      'title': "MLflow",
      'icon_path': '/opt/tools/logos/mlflow.svg',
    }
  }

if os.getenv('VS_CODE_ENABLED', 'false') == 'true':
  c.ServerProxy.servers['vscode'] = {
    'command': ['/bin/bash', '-c', '/opt/tools/bin/start-vscode.sh', '{port}'],
    'port': 7000,
    'absolute_url': False,
    'timeout': 30,
    'launcher_entry': {
      'title': "VSCode",
      'icon_path': '/opt/tools/logos/vs-code.svg',
    }
  }

# pylint: disable=anomalous-backslash-in-string, line-too-long, undefined-variable
c.NotebookApp.open_browser = False
c.ServerApp.token = ""
c.ServerApp.password = ""
c.ServerApp.port = 8080
c.ServerApp.allow_origin_pat = "(^https://8080-dot-[0-9]+-dot-devshell\.appspot\.com$)|(^https://colab\.(?:sandbox|research)\.google\.com$)|(^(https?://)?[0-9a-z\-]+\.[0-9a-z\-]+\.cloudshell\.dev$)|(^(https?://)ssh\.cloud\.google\.com/devshell$)"
c.ServerApp.allow_remote_access = True
# pylint: enable=anomalous-backslash-in-string, line-too-long, undefined-variable

BASE_PATH = "/opt/deeplearning/metadata/"
MAX_RETRIES = 2
METADATA_URL = "http://metadata/computeMetadata/v1"
METADATA_FLAVOR = {"Metadata-Flavor": "Google"}


def _get_session(prefix="http://", max_retries=MAX_RETRIES):
  """Return an HTTP Session.

  Args:
    prefix(str): Prefix for URL
    max_retries(int): Maximum number of retries each connection should attempt.

  Returns:
    A requests.Session()
  """
  session = requests.Session()
  session.mount(prefix, HTTPAdapter(max_retries=max_retries))
  return session


def get_jupyter_user():
  """Get default Jupyter user."""
  local_jupyter_user = "jupyter"
  if get_attribute_value("jupyter-user"):
    local_jupyter_user = get_attribute_value("jupyter-user")
  return local_jupyter_user


def get_attribute_value(attribute):
  """Get Metadata value.

  Args:
    attribute(str): Attribute key to look in Compute Metadata.

  Returns:
    Attribute value or None
  """
  if attribute is None:
    raise ValueError("Invalid attribute. Attribute is None")
  try:
    session = _get_session(max_retries=5)
    response = session.get(
        f"{METADATA_URL}/instance/attributes/{attribute}",
        headers=METADATA_FLAVOR,
    )
    response.raise_for_status()
    print(f"Metadata {attribute}:{response.text}")
    return response.text
  except requests.exceptions.HTTPError as err:
    if err.response.status_code == 404:
      print(err)
  return None


def handle_attribute_value(attribute_value):
  """If attribute value exists, check if its true or false."""
  if not attribute_value:
    return False
  if attribute_value.lower() == "true":
    return True
  return False


def _disable_downloads():
  """Disable file downloads from JupyterLab.

  Handlers are created at startup time.
  """
  local_jupyter_user = get_jupyter_user()
  jupyter_home = f"/home/{local_jupyter_user}"
  sys.path.append(f"{jupyter_home}/.jupyter/")
  # pylint: disable=unused-import,import-outside-toplevel,undefined-variable
  import handlers
  c.ContentsManager.files_handler_class = "handlers.ForbidFilesHandler"
  c.ContentsManager.files_handler_params = {}
  # Prevent export/printing of calculated values that likely have PII
  c.TemplateExporter.exclude_input_prompt = True
  c.TemplateExporter.exclude_output = True
  # pylint: enable=unused-import,import-outside-toplevel,undefined-variable


def read_from_file(path):
  """Read metadata file.

  Args:
    path(str): Location of file with metadata information.

  Returns:
    A string.
  """
  with open(path, "r", encoding="utf-8") as file:
    return file.read().replace("\n", "")


def get_env_name():
  return read_from_file(os.path.join(BASE_PATH, "env_version"))


def get_env_uri():
  return read_from_file(os.path.join(BASE_PATH, "env_uri"))


local_kernelspec_cache = {}


def get_gcloud_token():
  """Helper method to get an OAuth token from gcloud."""
  p = subprocess.run(
      ["gcloud", "auth", "print-access-token"],
      capture_output=True,
      check=True,
      encoding="UTF-8",
  )
  bearer_token = p.stdout.strip()
  return bearer_token


def gateway_client_connection_args(base_load_connection_args):
  """Extender for the `load_connection_args` method of the GatewayClient class."""

  # In-memory cache of the gcloud token.
  cached_gcloud_token = {
      "Created": datetime.datetime.now(),
      "Token": get_gcloud_token(),
  }

  def maybe_update_cached_token():
    """Fetch the cached token, refreshing it if necessary."""
    current_time = datetime.datetime.now()
    if (current_time - cached_gcloud_token["Created"]).total_seconds() > 300:
      cached_gcloud_token["Created"] = current_time
      cached_gcloud_token["Token"] = get_gcloud_token()
    return cached_gcloud_token["Token"]

  def updated_load_connection_args(*args, **kwargs):
    """Construct the args for a connection through the Enterprise Gateway."""
    connection_args = base_load_connection_args(*args, **kwargs)
    headers = connection_args.get("headers", {})
    connection_args["headers"] = headers

    bearer_token = maybe_update_cached_token()
    headers["Authorization"] = f"Bearer {bearer_token}"
    if "body" in kwargs:
      headers["Content-Type"] = "text/plain"
    return connection_args

  return updated_load_connection_args


def metadata_env_pre_save(model, **kwargs):  # pylint: disable=unused-argument
  """Save metadata from Jupyter Environment.

  Args:
    model(dict): Notebooks information
    **kwargs: Keyword Arguments.
  """

  try:
    # only run on notebooks
    if model["type"] != "notebook":
      return
    # only run on nbformat v4 or later
    if model["content"]["nbformat"] < 4:
      return
    model_metadata = model["content"]["metadata"]
    if "kernelspec" in model_metadata:
      kernel = model_metadata["kernelspec"]["name"]
      # remote kernels have no compatible container at the moment
      if kernel.startswith("remote-"):
        del model_metadata["kernelspec"]
        model_metadata["environment"] = {
            "type": "gcloud",
            "name": get_env_name(),
        }
        return
      # local kernels will have the local prefix in managed notebooks
      if kernel.startswith("local-"):
        kernel = kernel.split("-", 1)[1]
        if kernel not in local_kernelspec_cache:
          for k in kernelspec.find_kernel_specs():
            local_kernelspec_cache[k] = kernelspec.get_kernel_spec(k)
        kernel_metadata = local_kernelspec_cache[kernel].metadata
        model_metadata["environment"] = {
            "type": "gcloud",
            "name": get_env_name(),
            "uri": kernel_metadata["google.kernel_container"],
            # local name may not match kernel name on container
            "kernel": kernel_metadata["google.kernel_name"],
        }
        return
      # non-managed notebooks should have correct kernelspec listed
      model_metadata["environment"] = {
          "type": "gcloud",
          "name": get_env_name(),
          "uri": get_env_uri(),
          "kernel": kernel,
      }
  # pylint: disable=broad-except
  except (FileNotFoundError, KeyError, OSError, Exception) as e:
    logging.exception("Failed to enrich the Notebook with metadata: %s", e)

# pylint: disable=undefined-variable
c.FileContentsManager.pre_save_hook = metadata_env_pre_save

# Enable debugging
enable_debug = get_attribute_value("notebook-enable-debug")
if handle_attribute_value(enable_debug):
  c.Application.log_level = 0

# Allow cross-site requests
is_managed_notebook = get_attribute_value("runtime-resource-name")
disable_check_xsrf = get_attribute_value("disable-check-xsrf")
if handle_attribute_value(disable_check_xsrf) or is_managed_notebook:
  c.ServerApp.disable_check_xsrf = True

# https://jupyterlab.readthedocs.io/en/stable/user/rtc.html
use_collaborative = get_attribute_value("use-collaborative")
if handle_attribute_value(use_collaborative):
  print("Using JupyterLab Collaborative flag")
  c.LabApp.collaborative = True

disable_downloads = get_attribute_value("notebook-disable-downloads")
if handle_attribute_value(disable_downloads):
  _disable_downloads()

disable_terminal = get_attribute_value("notebook-disable-terminal")
if handle_attribute_value(disable_terminal):
  c.NotebookApp.terminals_enabled = False

c.FileContentsManager.delete_to_trash = False
delete_to_trash = get_attribute_value("notebook-enable-delete-to-trash")
if handle_attribute_value(delete_to_trash):
  c.FileContentsManager.delete_to_trash = True

# Handle case when user is using a custom jupyter-user.
jupyter_user = get_jupyter_user()
c.ServerApp.root_dir = f"/home/{jupyter_user}"

use_gateway_client = get_attribute_value("notebook-enable-gateway-client")
if handle_attribute_value(use_gateway_client):
  c.GatewayClient.load_connection_args = gateway_client_connection_args(
      c.GatewayClient.load_connection_args
  )
  c.GatewayClient.url = get_attribute_value("gateway-client-url")
  c.GatewayClient.http_user = get_attribute_value("gateway-client-http-user")

# Additional scripts append Jupyter configuration. Please keep this line.
