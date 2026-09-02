gke_clusters = {
  # Uncomment the block below whenever you are ready to provision the GKE cluster:
  # "platipus-gke-dev" = {
  #   location                     = "asia-east1"
  #   subnet_name                  = "asia-east1-01"
  #   pod_secondary_range_name     = "gke-pod-dev-1"
  #   service_secondary_range_name = "gke-svc-dev-1"
  #   master_ipv4_cidr_block       = "172.16.0.0/28"
  #   enable_private_nodes         = true
  #   enable_private_endpoint      = false
  #   gateway_api_channel          = "CHANNEL_STANDARD"
  #   release_channel              = "REGULAR"
  #   deletion_protection          = false
  #   node_pools = {
  #     "system-pool" = {
  #       machine_type = "e2-standard-2"
  #       disk_size_gb = 30
  #       disk_type    = "pd-standard"
  #       is_spot      = true
  #       node_count   = 1
  #       tags         = ["gke-node", "dev-system"]
  #       labels = {
  #         "environment" = "dev"
  #         "role"        = "system"
  #       }
  #     },
  #     "custom-workload-pool" = {
  #       machine_type = "e2-standard-4"
  #       disk_size_gb = 50
  #       disk_type    = "pd-ssd"
  #       is_spot      = true
  #       autoscaling = {
  #         min_node_count = 1
  #         max_node_count = 3
  #       }
  #       tags = ["gke-node", "dev-workload"]
  #       labels = {
  #         "environment" = "dev"
  #         "role"        = "workload"
  #       }
  #     }
  #   }
  # }
}
