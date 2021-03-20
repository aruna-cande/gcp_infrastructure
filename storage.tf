resource "google_storage_bucket" "importer_data" {
  name          = "geolocation-importer-data"
  location      = "US"
  force_destroy = true
}