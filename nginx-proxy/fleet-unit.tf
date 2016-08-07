resource "template_file" "nginx_proxy_unit" {
  template = "${file("${path.module}/templates/nginx-proxy.service")}"

  vars {
    private_dns_zone_name = "${var.private_dns_zone_name}"
  }
}

resource "null_resource" "copy_unit" {
  count = "${var.cluster_size}"

  # Changes to any instance of the cluster requires re-provisioning
  triggers {
    cluster_instance_ids = "${var.node_ids}"
  }

  # Copy units to all cluster nodes
  connection {
    bastion_host = "${var.bastion_host}"
    bastion_user = "${var.bastion_user}"
    host         = "${element(var.node_private_ips, count.index)}"
    user         = "${var.node_user}"
  }

  provisioner "remote-exec" {
    inline = [
      # Copy systemd unit file
      "cat <<EOF > /home/core/nginx-proxy.service",
      "${template_file.nginx_proxy_unit.rendered}",
      "EOF",
    ]
  }
}
