resource "null_resource" "build_release" {
  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    bastion_host = "${var.bastion_host}"
    bastion_user = "${var.bastion_user}"
    host         = "${element(split(",", var.node_private_ips), 0)}"
    user         = "${var.node_user}"
  }

  provisioner "remote-exec" {
    # Build a container and push it to the private registry
    inline = [
      "git clone https://github.com/RichardKnop/example-api.git",
      "docker build -t example-api:latest example-api/",
      "docker tag example-api:latest registry.local/example-api",
      "docker push registry.local/example-api",
    ]
  }
}
