resource "docker_image" "jupyter" {
  name = "${var.registry_hostname}/${var.registry_repo_name}/jupyter:${var.jupyterlab_version}"
  build {
    context = "${path.module}/resources"
    build_args = {
      JUPYTERLAB_VERSION : var.jupyterlab_version
      SPARK_VERSION : var.spark_version
      PROJECT_NAME : var.project_name
      GCS_CONNECTOR_VERSION : var.gcs_connector_version
      DBT_VERSION : var.dbt_version
      DBT_SPARK_VERSION : var.dbt_spark_version
    }
    tag      = ["${var.registry_hostname}/${var.registry_repo_name}/jupyter:latest"]
    platform = "amd64"
  }
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.cwd, "${path.module}/resources/**") : filesha1(f)]))
  }
}


resource "docker_registry_image" "jupyterlab" {
  name          = docker_image.jupyter.name
  keep_remotely = true
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.cwd, "${path.module}/resources/**") : filesha1(f)]))
  }
}