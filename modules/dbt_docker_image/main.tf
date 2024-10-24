resource "docker_image" "dbt" {
  name = "${var.registry_hostname}/${var.registry_repo_name}/dbt:${var.dbt_version}"
  build {
    context = "${path.module}/resources"
    build_args = {
      DBT_VERSION : var.dbt_version
      DBT_SPARK_VERSION : var.dbt_spark_version
      SPARK_VERSION : var.spark_version
      PROJECT_NAME : var.project_name
    }
    tag      = ["${var.registry_hostname}/${var.registry_repo_name}/dbt:latest"]
    platform = "amd64"
  }
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.cwd, "${path.module}/resources/**") : filesha1(f)]))
  }
}


resource "docker_registry_image" "dbt" {
  name          = docker_image.dbt.name
  keep_remotely = true
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.cwd, "${path.module}/resources/**") : filesha1(f)]))
  }
}