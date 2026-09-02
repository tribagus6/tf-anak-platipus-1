data "terraform_remote_state" "foundations" {
  backend = "gcs"
  config = {
    bucket = "bokap-platipus-tfstate"
    prefix = "foundations"
  }
}

module "compute_vms" {
  source   = "git::https://github.com/tribagus6/tf-gcp-module.git//modules/compute-engine"
  for_each = var.vms

  instance_name            = each.key
  project_id               = var.service_project_id
  zone                     = var.zone
  region                   = var.region
  machine_type             = each.value.machine_type
  image                    = each.value.image
  disk_size_gb             = each.value.disk_size_gb
  subnetwork               = data.terraform_remote_state.foundations.outputs.subnet_self_links[each.value.subnet_name]
  is_spot                  = each.value.is_spot
  add_public_ip            = each.value.add_public_ip
  use_static_ip            = try(each.value.use_static_ip, false)
  network_tier             = each.value.network_tier
  max_run_duration_seconds = each.value.max_run_duration_seconds
  metadata_startup_script  = each.value.startup_script_path != null ? file("${path.module}/${each.value.startup_script_path}") : null
}

module "gke_clusters" {
  source   = "git::https://github.com/tribagus6/tf-gcp-module.git//modules/gke"
  for_each = var.gke_clusters

  project_id                        = var.service_project_id
  cluster_name                      = each.key
  location                          = coalesce(each.value.location, var.region, var.zone)
  subnetwork                        = data.terraform_remote_state.foundations.outputs.subnet_self_links[each.value.subnet_name]
  pod_secondary_range_name          = each.value.pod_secondary_range_name
  service_secondary_range_name      = each.value.service_secondary_range_name
  master_ipv4_cidr_block            = each.value.master_ipv4_cidr_block
  enable_private_nodes              = each.value.enable_private_nodes
  enable_private_endpoint           = each.value.enable_private_endpoint
  gateway_api_channel               = each.value.gateway_api_channel
  release_channel                   = each.value.release_channel
  deletion_protection               = each.value.deletion_protection
  master_authorized_networks_config = each.value.master_authorized_networks_config
  node_pools                        = each.value.node_pools
}
