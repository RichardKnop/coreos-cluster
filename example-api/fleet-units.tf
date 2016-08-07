resource "template_file" "api_unit" {
  template = "${file("${path.module}/templates/example-api.service")}"

  vars {
    private_dns_zone_name = "${var.private_dns_zone_name}"
    virtual_host = "${var.virtual_host}"
  }
}

resource "null_resource" "bootstrap_units" {
  count = "${var.cluster_size}"
  depends_on = ["null_resource.build_release"]

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
      "cat <<EOF > /home/core/example-api.service",
      "${template_file.api_unit.rendered}",
      "EOF",
      # Load the unit
      "/usr/bin/fleetctl start /home/core/example-api.service",
    ]
  }
}
