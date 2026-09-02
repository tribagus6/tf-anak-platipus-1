variable "service_project_id" {
  description = "The GCP project ID where workloads will be deployed"
  type        = string
}

variable "zone" {
  type    = string
  default = "asia-east1-a"
}

variable "region" {
  type    = string
  default = "asia-east1"
}

variable "vms" {
  description = "Map of Compute Engine VMs to create"
  type = map(object({
    machine_type             = string
    image                    = string
    disk_size_gb             = number
    is_spot                  = bool
    add_public_ip            = bool
    network_tier             = optional(string, "STANDARD")
    max_run_duration_seconds = optional(number)
    subnet_name              = string
    startup_script_path      = optional(string)
  }))
  default = {}
}

variable "gke_clusters" {
  description = "Map of GKE Standard clusters to provision"
  type = map(object({
    location                     = optional(string)
    subnet_name                  = string
    pod_secondary_range_name     = optional(string, "gke-pod-dev-1")
    service_secondary_range_name = optional(string, "gke-svc-dev-1")
    master_ipv4_cidr_block       = optional(string, "172.16.0.0/28")
    enable_private_nodes         = optional(bool, true)
    enable_private_endpoint      = optional(bool, false)
    gateway_api_channel          = optional(string, "CHANNEL_STANDARD")
    release_channel              = optional(string, "REGULAR")
    deletion_protection          = optional(bool, false)
    master_authorized_networks_config = optional(list(object({
      cidr_block   = string
      display_name = string
    })), [])
    node_pools = optional(map(object({
      machine_type = optional(string, "e2-medium")
      disk_size_gb = optional(number, 50)
      disk_type    = optional(string, "pd-standard")
      is_spot      = optional(bool, true)
      node_count   = optional(number)
      autoscaling = optional(object({
        min_node_count = number
        max_node_count = number
      }))
      max_pods_per_node = optional(number)
      service_account   = optional(string)
      tags              = optional(list(string), [])
      labels            = optional(map(string), {})
    })), {})
  }))
  default = {}
}
