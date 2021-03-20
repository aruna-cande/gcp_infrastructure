data "kubectl_path_documents" "ci_cd_pipeline_role_manifests" {
    pattern = "./manifests/roles/*.yaml"
    vars = {
      unique_id = google_service_account.ci_cd_account.unique_id
    }
}

resource "kubectl_manifest" "ci_cd_pipeline_role" {
    count     = length(data.kubectl_path_documents.ci_cd_pipeline_role_manifests.documents)
    yaml_body = element(data.kubectl_path_documents.ci_cd_pipeline_role_manifests.documents, count.index)
    depends_on = [kubectl_manifest.namespace]
}

data "kubectl_path_documents" "db_secrets" {
    pattern = "./manifests/secrets/*.yaml"
    vars = {
        user = base64encode(data.google_secret_manager_secret_version.db_user.secret_data)
        password = base64encode(data.google_secret_manager_secret_version.db_password.secret_data)
    }
}

resource "kubectl_manifest" "db_secrets" {
    count     = length(data.kubectl_path_documents.db_secrets.documents)
    yaml_body = element(data.kubectl_path_documents.db_secrets.documents, count.index)
    depends_on = [kubectl_manifest.namespace]
}

data "kubectl_path_documents" "config_maps" {
    pattern = "./manifests/configmaps/*.yaml"
    vars = {
        postgres_host = google_sql_database_instance.instance.private_ip_address
        postgres_port = "5432"
        postgres_db = var.postgres_dbname
        api_port = "8080"
    }
}

resource "kubectl_manifest" "config_maps" {
    count     = length(data.kubectl_path_documents.config_maps.documents)
    yaml_body = element(data.kubectl_path_documents.config_maps.documents, count.index)
    depends_on = [kubectl_manifest.namespace]
}

data "kubectl_path_documents" "storage" {
    pattern = "./manifests/storage/*.yaml"
}

resource "kubectl_manifest" "storage" {
    count     = length(data.kubectl_path_documents.storage.documents)
    yaml_body = element(data.kubectl_path_documents.storage.documents, count.index)
    depends_on = [kubectl_manifest.namespace]
}

data "kubectl_path_documents" "namespace" {
    pattern = "./manifests/namespace/*.yaml"
}

resource "kubectl_manifest" "namespace" {
    count     = length(data.kubectl_path_documents.namespace.documents)
    yaml_body = element(data.kubectl_path_documents.namespace.documents, count.index)
}