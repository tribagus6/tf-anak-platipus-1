output "gke_clusters" {
  description = "Outputs for the provisioned GKE clusters"
  value = {
    for k, v in module.gke_clusters : k => {
      cluster_name = v.cluster_name
      cluster_id   = v.cluster_id
      endpoint     = v.endpoint
      node_pools   = v.node_pools
    }
  }
}
