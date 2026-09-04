vms = {
  "platipus-atlantis" = {
    machine_type             = "e2-medium"
    image                    = "debian-cloud/debian-12"
    disk_size_gb             = 30
    is_spot                  = false
    add_public_ip            = true
    static_ip_address        = "35.194.222.101"
    network_tier             = "PREMIUM"
    max_run_duration_seconds = null
    subnet_name              = "subnet-01"
    startup_script_path      = null
  },
  "platipus-ci" = {
    machine_type             = "e2-medium"
    image                    = "debian-cloud/debian-12"
    disk_size_gb             = 30
    is_spot                  = true
    add_public_ip            = true
    network_tier             = "STANDARD"
    max_run_duration_seconds = 18000 # 5 hours (5 * 3600 seconds)
    subnet_name              = "subnet-01"
    startup_script_path      = "scripts/jenkins-startup.sh"
  }
}
