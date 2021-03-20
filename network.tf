resource "google_compute_network" "primary" {
  name                    = var.vpc_name
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
  project                 = google_project.default.project_id
}

resource "google_compute_subnetwork" "app_subnet" {
  name          = "app-subnet"
  ip_cidr_range = var.app_subnet
  region        = var.region
  network       = google_compute_network.primary.id
}

resource "google_compute_firewall" "allow-ssh" {
  name        = "allow-ssh"
  network     = google_compute_network.primary.name
  direction   = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["ssh-allowed"]
}