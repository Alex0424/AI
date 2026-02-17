# Static IP

resource "google_compute_address" "ai_ip" {
  name = "ai-static-ip"
  region = var.region

  lifecycle {
    prevent_destroy = true
  }
}


# Firewall

resource "google_compute_firewall" "allow_http_https" {
  name    = "allow-http-https"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ai-server"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ai-server"]
}

# VM

resource "google_compute_instance" "ai_vm" {
  name         = "ai-rag-vm"
  machine_type = var.machine_type
  zone         = var.zone

  depends_on = [
    google_compute_address.ai_ip
  ]

  tags = ["ai-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 60
    }
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.ai_ip.address
    }
  }

  metadata = {
    ssh-keys = "ansible:${file("/home/runner/.ssh/gcp-ansible.pub")}" # Default: ~/.ssh/gcp-ansible.pub
  }

  #metadata_startup_script = file("${path.module}/cloud_script_install.sh")

}

