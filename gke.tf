resource "google_container_cluster" "main" {
  name = var.cluster_name
  location = var.zone
  network = google_compute_network.main.id
  subnetwork = google_compute_subnetwork.main.id
  remove_default_node_pool = true
  initial_node_count = 1
  deletion_protection = false # Sandbox only; enable for production.
  ip_allocation_policy {
    cluster_secondary_range_name = "pods"
    services_secondary_range_name = "services"
  }
  workload_identity_config { workload_pool = "${var.project_id}.svc.id.goog" }
  release_channel { channel = "REGULAR" }
  depends_on = [google_project_service.required]
}
resource "google_container_node_pool" "cpu" {
  name = "cpu-pool"
  cluster = google_container_cluster.main.id
  node_count = var.node_count
  node_config {
    machine_type = var.node_machine_type
    disk_size_gb = 50
    service_account = google_service_account.nodes.email
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    workload_metadata_config { mode = "GKE_METADATA" }
    metadata = { disable-legacy-endpoints = "true" }
  }
  management { 
    auto_repair = true
    auto_upgrade = true 
  }
  depends_on = [google_project_iam_member.node_roles]
}
