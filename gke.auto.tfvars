gke_clusters = {
  # Uncomment the block below whenever you are ready to provision the GKE cluster:
  "platipus-gke-dev" = {
    location                     = "asia-east1"
    subnet_name                  = "subnet-01"
    pod_secondary_range_name     = "gke-pod-dev-1"
    service_secondary_range_name = "gke-svc-dev-1"
    master_ipv4_cidr_block       = "172.16.0.0/28"
    enable_private_nodes         = true
    enable_private_endpoint      = false
    datapath_provider            = "ADVANCED_DATAPATH"
    gateway_api_channel          = "CHANNEL_STANDARD"
    release_channel              = "REGULAR"
    deletion_protection          = false
    node_pools = {
      "system-pool" = {
        machine_type = "e2-standard-2"
        disk_size_gb = 30
        disk_type    = "pd-standard"
        is_spot      = true
        node_count   = 2
        tags         = ["gke-node", "dev-system"]
        labels = {
          "environment" = "dev"
          "role"        = "system"
        }
      }
    }
  }
}
