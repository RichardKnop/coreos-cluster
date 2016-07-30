resource "null_resource" "build_release" {
  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    bastion_host = "${var.bastion_host}"
    bastion_user = "${var.bastion_user}"
    host         = "${var.registry_private_ip}"
    user         = "${var.registry_user}"
  }

  provisioner "remote-exec" {
    # Build a container and push it to the private registry
    inline = [
      "if cd ${var.git_dest}; then git pull; else git clone ${var.git_repo} ${var.git_dest}; cd ${var.git_dest}; fi",
      "./build-release.sh ${var.version} --no-dry-run -y",
    ]
  }
}
