provider "vsphere" {
  user                 = "${var.vsphere_user}"
  password             = "${var.vsphere_password}"
  vsphere_server       = "${var.vsphere_server}"
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_datacenter}"
}

module "folder" {
  source = "./folder"

  path          = "${var.cluster_id}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

module "resource_pool" {
  source = "./resource_pool"

  name            = "${var.cluster_id}"
  datacenter_id   = "${data.vsphere_datacenter.dc.id}"
  vsphere_cluster = "${var.vsphere_cluster}"
}

module "bootstrap" {
  source = "./bs_machine"

  name             = ["${compact(list(var.bootstrap_name))}"]
  instance_count   = "${var.bootstrap_complete ? 0 : 1}"
  ignition_url     = "${var.bootstrap_ignition_url}"
  resource_pool_id = "${module.resource_pool.pool_id}"
  datastore        = "${var.vsphere_datastore}"
  folder           = "${module.folder.path}"
  network          = "${var.vm_network}"
  datacenter_id    = "${data.vsphere_datacenter.dc.id}"
  template         = "${var.vm_template}"
  cluster_domain   = "${var.cluster_domain}"
  ipam             = "${var.ipam}"
  ipam_token       = "${var.ipam_token}"
  ip_addresses     = ["${compact(list(var.bootstrap_ip))}"]
  machine_cidr     = "${var.machine_cidr}"
  dns1             = "${var.dns1}"
}

module "control_plane" {
  source = "./control_machine"

  name             = ["${var.control_plane_names}"]
  instance_count   = "${var.control_plane_count}"
  ignition         = "${var.control_plane_ignition}"
  resource_pool_id = "${module.resource_pool.pool_id}"
  folder           = "${module.folder.path}"
  datastore        = "${var.vsphere_datastore}"
  network          = "${var.vm_network}"
  datacenter_id    = "${data.vsphere_datacenter.dc.id}"
  template         = "${var.vm_template}"
  cluster_domain   = "${var.cluster_domain}"
  ipam             = "${var.ipam}"
  ipam_token       = "${var.ipam_token}"
  ip_addresses     = ["${var.control_plane_ips}"]
  machine_cidr     = "${var.machine_cidr}"
  dns1             = "${var.dns1}"
}

module "compute" {
  source = "./compute_machine"

  name             = ["${var.compute_names}"]
  instance_count   = "${var.compute_count}"
  ignition         = "${var.compute_ignition}"
  resource_pool_id = "${module.resource_pool.pool_id}"
  folder           = "${module.folder.path}"
  datastore        = "${var.vsphere_datastore}"
  network          = "${var.vm_network}"
  datacenter_id    = "${data.vsphere_datacenter.dc.id}"
  template         = "${var.vm_template}"
  cluster_domain   = "${var.cluster_domain}"
  ipam             = "${var.ipam}"
  ipam_token       = "${var.ipam_token}"
  ip_addresses     = ["${var.compute_ips}"]
  machine_cidr     = "${var.machine_cidr}"
  dns1             = "${var.dns1}"
}

module "storage" {
  source = "./storage_machine"

  name             = ["${var.storage_names}"]
  instance_count   = "${var.storage_count}"
  ignition         = "${var.compute_ignition}"
  resource_pool_id = "${module.resource_pool.pool_id}"
  folder           = "${module.folder.path}"
  datastore        = "${var.vsphere_datastore}"
  network          = "${var.vm_network}"
  datacenter_id    = "${data.vsphere_datacenter.dc.id}"
  template         = "${var.vm_template}"
  cluster_domain   = "${var.cluster_domain}"
  ipam             = "${var.ipam}"
  ipam_token       = "${var.ipam_token}"
  ip_addresses     = ["${var.storage_ips}"]
  machine_cidr     = "${var.machine_cidr}"
  dns1             = "${var.dns1}"
}


#module "dns" {
#  source = "./route53"
#
#  base_domain         = "${var.base_domain}"
#  cluster_domain      = "${var.cluster_domain}"
#  bootstrap_count     = "${var.bootstrap_complete ? 0 : 1}"
#  bootstrap_ips       = ["${module.bootstrap.ip_addresses}"]
#  control_plane_count = "${var.control_plane_count}"
#  control_plane_ips   = ["${module.control_plane.ip_addresses}"]
#  compute_count       = "${var.compute_count}"
#  compute_ips         = ["${module.compute.ip_addresses}"]
#}
