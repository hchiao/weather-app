# VPC
resource "google_compute_network" "vpc" {
  name                    = "${local.project_id}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${local.project_id}-subnet"
  region        = local.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = local.vpc_cidr

  secondary_ip_range {
    range_name    = local.cluster_secondary_range_name
    ip_cidr_range = local.cluster_secondary_cidr
  }

  secondary_ip_range {
    range_name    = local.services_secondary_range_name
    ip_cidr_range = local.services_secondary_cidr
  }
}
