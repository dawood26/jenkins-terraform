terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}
provider "libvirt" {
  uri = "qemu+ssh://root@192.168.122.1/system"
}
resource "libvirt_volume" "server1-qcow2" {
  name = "server1.qcow2"
  pool = "default"
  source = "https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2"
  #source = "/mnt/ISO/FreeBSD-13.0-RELEASE-amd64.qcow2"
  format = "qcow2"
}
# Define KVM domain to create
resource "libvirt_domain" "server1" {
  name   = "server1"
  memory = "2048"
  vcpu   = 2
  network_interface {
    network_name = "default"
  }
  disk {
    volume_id = libvirt_volume.server1-qcow2.id
  }
  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }
  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }
}
