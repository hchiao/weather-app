locals {
  # basic
  project_id                    = "gke-hello-world-253604"
  region                        = "australia-southeast1"

  # networks
  vpc_cidr                      = "10.10.0.0/24"
  cluster_secondary_cidr        = "10.0.0.0/18"
  services_secondary_cidr       = "10.64.0.0/18"
  cluster_secondary_range_name  = "cluster-secondary-range"
  services_secondary_range_name = "services-secondary-range"
}
