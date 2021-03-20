provider "google" {
  project = var.project
  region  = var.region
  credentials = "terraform-account.json"
}

terraform {
  backend "gcs" {
    bucket = "playground-infra-state"
    prefix = "gcp-infrastructure"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.51.0"
    }

    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.10.0"
    }
  }
  required_version = ">=0.13"
}

resource "google_project" "default" {
  name       = var.project
  project_id = var.project
}
