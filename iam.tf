resource "google_service_account" "nodes" {
  account_id = "ai-studio-gke-nodes"
  display_name = "AI Studio GKE nodes"
  depends_on = [google_project_service.required]
}
resource "google_project_iam_member" "node_roles" {
  for_each = toset(["roles/container.defaultNodeServiceAccount", "roles/artifactregistry.reader"])
  project = var.project_id
  role = each.value
  member = "serviceAccount:${google_service_account.nodes.email}"
}
resource "google_service_account" "backend" {
  account_id = "ai-studio-backend"
  display_name = "AI Studio backend Vertex AI identity"
  depends_on = [google_project_service.required]
}
resource "google_project_iam_member" "vertex" {
  project = var.project_id
  role = "roles/aiplatform.user"
  member = "serviceAccount:${google_service_account.backend.email}"
}
resource "google_service_account_iam_member" "backend_wi" {
  service_account_id = google_service_account.backend.name
  role = "roles/iam.workloadIdentityUser"
  member = "serviceAccount:${var.project_id}.svc.id.goog[ai-studio/backend]"
}
