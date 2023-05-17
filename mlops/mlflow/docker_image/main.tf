resource "docker_image" "mlflow" {
  name = "${var.registry_hostname}/${var.registry_repo_name}/mlflow:${var.mlflow_version}"
  build {
    context = "${path.module}/resources"
    build_args = {
      MLFLOW_VERSION : var.mlflow_version
    }
    tag = ["${var.registry_hostname}/${var.registry_repo_name}/mlflow:latest"]
    label = {
      author : "mlops@getindata.com"
    }
  }
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.cwd, "${path.module}/resources/*") : filesha1(f)]))
  }
}


resource "docker_registry_image" "mlflow" {
  name          = docker_image.mlflow.name
  keep_remotely = true
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.cwd, "${path.module}/resources/*") : filesha1(f)]))
  }
}