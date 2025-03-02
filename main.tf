provider "google" {
    project = "sam-452209"
    zone = "us-central1"

  
}
locals {
  l1= ["instance1","instance2"]

}
resource "google_compute_instance" "inst1" {
    count = length(local.l1)
    name = local.l1[count.index]
    machine_type = "e2-medium"
    boot_disk {
      initialize_params {
        image = "centos-stream-9"

      }
      
    }
  
  network_interface {
    network = "default"
    access_config {
      
    }
  }
}
