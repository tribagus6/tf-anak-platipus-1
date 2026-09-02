vms = {
  "platipus-atlantis" = {
    machine_type             = "e2-medium"
    image                    = "debian-cloud/debian-12"
    disk_size_gb             = 30
    is_spot                  = false
    add_public_ip            = true
    static_ip_address        = "35.194.222.101" # Promoted Static IP (ipx-atlantis-01)
    network_tier             = "STANDARD"
    max_run_duration_seconds = null
    subnet_name              = "subnet-01"
    startup_script_path      = null
  }
}
