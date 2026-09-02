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
    network_tier             = optional(string)
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
    pod_secondary_range_name     = optional(string)
    service_secondary_range_name = optional(string)
    master_ipv4_cidr_block       = optional(string)
    enable_private_nodes         = optional(bool)
    enable_private_endpoint      = optional(bool)
    gateway_api_channel          = optional(string)
    release_channel              = optional(string)
    deletion_protection          = optional(bool)
    master_authorized_networks_config = optional(list(object({
      cidr_block   = string
      display_name = string
    })))
    node_pools = optional(map(object({
      machine_type = optional(string)
      disk_size_gb = optional(number)
      disk_type    = optional(string)
      is_spot      = optional(bool)
      node_count   = optional(number)
      autoscaling = optional(object({
        min_node_count = number
        max_node_count = number
      }))
      max_pods_per_node = optional(number)
      service_account   = optional(string)
      tags              = optional(list(string))
      labels            = optional(map(string))
    })))
  }))
  default = {}
}
