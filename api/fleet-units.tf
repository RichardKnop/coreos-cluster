resource "template_file" "nginx_proxy_unit" {
  template = "${file("${path.module}/templates/nginx-proxy.service")}"

  vars {
    private_dns_zone_name = "${var.private_dns_zone_name}"
  }
}

resource "template_file" "api_unit" {
  template = "${file("${path.module}/templates/example-api.service")}"

  vars {
    private_dns_zone_name = "${var.private_dns_zone_name}"
    dns_zone_name = "${var.dns_zone_name}"
    dns_prefix = "${var.dns_prefix}"
  }
}

resource "null_resource" "copy_units" {
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
    # Write configuration to etcd
    inline = [
      "cat <<EOF > /home/core/nginx-proxy.service",
      "${template_file.nginx_proxy_unit.rendered}",
      "EOF",
      "cat <<EOF > /home/core/example-api.service",
      "${template_file.api_unit.rendered}",
      "EOF",
    ]
  }
}
