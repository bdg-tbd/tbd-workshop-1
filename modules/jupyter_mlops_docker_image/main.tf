resource "docker_image" "jupyter-mlops" {
  name = "${var.registry_hostname}/${var.registry_repo_name}/jupyter-mlops:${var.jupyterlab_version}"
  build {
    context = "${path.module}/resources"
    build_args = {
      JUPYTERLAB_VERSION : var.jupyterlab_version
      SPARK_VERSION : var.spark_version
      PROJECT_NAME : var.project_name
      GCS_CONNECTOR_VERSION : var.gcs_connector_version
      DBT_VERSION : var.dbt_version
      DBT_SPARK_VERSION : var.dbt_spark_version
      MLFLOW_VERSION : var.mlflow_version
      KEDRO_VERSION : var.kedro_version
      VS_CODE_VERSION : var.vs_code_version
      # FIXME: even if we set env vars here they need to injected again in the notebook_post_startup_script.sh
      # check modules/vertex-ai-workbench/resources/notebook_post_startup_script.sh
    }
    tag = ["${var.registry_hostname}/${var.registry_repo_name}/jupyter-mlops:latest"]
  }
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.cwd, "${path.module}/resources/**") : filesha1(f)]))
  }
}


resource "docker_registry_image" "jupyterlab" {
  name          = docker_image.jupyter-mlops.name
  keep_remotely = true
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.cwd, "${path.module}/resources/**") : filesha1(f)]))
  }
}