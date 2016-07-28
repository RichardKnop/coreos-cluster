resource "null_resource" "api_config" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers {
    cluster_instance_ids = "${join(",", aws_instance.node.*.id)}"
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    bastion_host = "${var.nat_public_ip}"
    bastion_user = "ec2-user"
    host = "${element(aws_instance.node.*.private_ip, 0)}"
    user = "core"
  }

  provisioner "remote-exec" {
    # Bootstrap script to load data into ETCD
    inline = [
      "etcdctl set /config/example_api.json ${var.api_config}"
    ]
  }
}
