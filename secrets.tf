data "google_secret_manager_secret_version" "db_user" {
  secret = "projects/574561305035/secrets/db_user"
}

data "google_secret_manager_secret_version" "db_password" {
  secret = "projects/574561305035/secrets/db_password"
}
