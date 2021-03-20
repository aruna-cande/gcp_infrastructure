resource "google_service_account" "terraform_account" {
  account_id   = "terraform"
  display_name = "terraform"
  description  = "This service account will be used  in order to allow terraform to manage gcp resources"
}

resource "google_service_account" "k8s_account" {
  account_id   = "kubernetes-account"
  display_name = "Kubernetes service account"
  description = "This service account will be used as admin account for kubernetes"
}

resource "google_service_account" "ci_cd_account" {
  account_id   = "ci-cd-account"
  display_name = "ci/cd account"
  description = "This service account will be used to allow ci/cd services to deploy containers into kubernetes clusters"
}

/*
While Kubernetes RBAC can be used instead of IAM for almost all cases,
GKE users are required at least the container.clusters.get IAM permission in the project containing the cluster.
This permission is included by the container.clusterViewer role, as well as the other, more highly privileged roles.
The container.clusters.get permission is required for users to authenticate to the clusters in the project
*/
resource "google_project_iam_binding" "project" {
  project = var.project
  role    = "roles/container.clusterViewer"

  members = [
    "serviceAccount:${google_service_account.k8s_account.email}",
    "serviceAccount:${google_service_account.ci_cd_account.email}",
  ]
}

resource "google_storage_bucket_iam_member" "admin" {
  bucket = google_container_registry.registry.id
  role = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.ci_cd_account.email}"
}

resource "google_storage_bucket_iam_member" "k8s_account" {
  bucket = google_container_registry.registry.id
  role = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.k8s_account.email}"
}

resource "google_storage_bucket_iam_member" "importer_data" {
  bucket = google_storage_bucket.importer_data.id
  role = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.k8s_account.email}"
}