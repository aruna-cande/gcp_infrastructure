resource "google_container_cluster" "primary" {
  name     = "${google_project.default.name}-gke-cluster"
  location = var.region

  network    = google_compute_network.primary.id
  subnetwork = google_compute_subnetwork.app_subnet.self_link

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/16"
    services_ipv4_cidr_block = "/20"
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_project.default.name}-general-purpose"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = false
    machine_type = var.machine_type

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.k8s_account.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_write",
    ]
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}