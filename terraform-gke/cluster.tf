# GKE cluster
resource "google_container_cluster" "primary" {
  name               = "weather-cluster"
  location           = local.region
  remove_default_node_pool = true
  initial_node_count       = 1

  workload_identity_config {
    workload_pool = "${local.project_id}.svc.id.goog"
  }

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  # https://cloud.google.com/kubernetes-engine/docs/concepts/alias-ips#cluster_sizing
  ip_allocation_policy {
    cluster_secondary_range_name  = local.cluster_secondary_range_name
    services_secondary_range_name = local.services_secondary_range_name
  }
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.primary.name}-node-pool"
  location   = local.region
  cluster    = google_container_cluster.primary.name
  node_count = 2

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      foo = "bar"
    }
    machine_type = "n1-standard-1"
    tags         = ["gke-node", "gke-hello-world-253604-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
