output "project_id" {
  value = google_project.default.id
}

//IAM
output "k8s_account_id" {
  value = google_service_account.k8s_account.account_id
}

output "terraform_account_id" {
  value = google_service_account.terraform_account.account_id
}

output "ci_cd_account_id" {
  value = google_service_account.ci_cd_account.account_id
}

//GKE
/*output "client_certificate" {
  value = google_container_cluster.primary.master_auth.0.client_certificate
}

output "client_key" {
  value = google_container_cluster.primary.master_auth.0.client_key
}

output "cluster_ca_certificate" {
  value = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
}*/

//Network
output "vpc_id" {
  value = google_compute_network.primary.id
}

output "app-subnet" {
  value = google_compute_subnetwork.app_subnet.self_link
}