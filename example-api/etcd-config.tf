resource "null_resource" "etcd_config" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers {
    cluster_instance_ids = "${var.node_ids}"
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    bastion_host = "${var.bastion_host}"
    bastion_user = "${var.bastion_user}"
    host         = "${element(var.node_private_ips, 0)}"
    user         = "${var.node_user}"
  }

  provisioner "remote-exec" {
    inline = [
      # Write configuration to etcd
      "source /etc/profile.d/etcd-envvars.sh",
      "etcdctl set ${var.etcd_path} '${var.etcd_config}'",
    ]
  }
}
