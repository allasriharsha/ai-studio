output "cluster_name" { value = google_container_cluster.main.name }
output "cluster_location" { value = google_container_cluster.main.location }
output "registry" { value = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.containers.repository_id}" }
output "backend_service_account" { value = google_service_account.backend.email }
output "get_credentials" { value = "gcloud container clusters get-credentials ${google_container_cluster.main.name} --zone ${var.zone} --project ${var.project_id}" }
