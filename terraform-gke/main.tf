provider "google" {
  project = "gke-hello-world-253604"
  region  = "australia-southeast1"
  zone    = "australia-southeast1-a"
}

resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

locals {
  cluster_secondary_range_name  = "cluster-secondary-range"
  services_secondary_range_name = "services-secondary-range"
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = "gke-hello-world-253604-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "gke-hello-world-253604-subnet"
  region        = "australia-southeast1"
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"

  secondary_ip_range {
    range_name    = local.cluster_secondary_range_name
    ip_cidr_range = "10.0.0.0/18"
  }

  secondary_ip_range {
    range_name    = local.services_secondary_range_name
    ip_cidr_range = "10.64.0.0/18"
  }
}

# GKE cluster
resource "google_container_cluster" "primary" {
  name               = "weather-cluster"
  location           = "australia-southeast1"
  remove_default_node_pool = true
  initial_node_count       = 1

  workload_identity_config {
    workload_pool = "gke-hello-world-253604.svc.id.goog"
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
  location   = "australia-southeast1"
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
