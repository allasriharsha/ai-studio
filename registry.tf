resource "google_artifact_registry_repository" "containers" {
  location      = var.region
  repository_id = "ai-studio"
  description   = "AI Studio application images"
  format        = "DOCKER"
  depends_on    = [google_project_service.required]
}
