resource "docker_image" "jupyter" {
  name = "${var.registry_hostname}/${var.registry_repo_name}/jupyter:${var.jupyterlab_version}"
  build {
    context = "${path.module}/resources"
    build_args = {
      JUPYTERLAB_VERSION : var.jupyterlab_version
    }
    tag = ["${var.registry_hostname}/${var.registry_repo_name}/jupyter:latest"]
  }
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.cwd, "${path.module}/resources/*") : filesha1(f)]))
  }
}


resource "docker_registry_image" "jupyterlab" {
  name          = docker_image.jupyter.name
  keep_remotely = true
}