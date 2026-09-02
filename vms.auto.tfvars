vms = {
  "platipus-cicd" = {
    machine_type             = "e2-custom-4-8192"
    image                    = "debian-cloud/debian-12"
    disk_size_gb             = 30
    is_spot                  = true
    add_public_ip            = true
    max_run_duration_seconds = 18000 # 5 hours
    subnet_name              = "subnet-01"
    startup_script_path      = "scripts/startup.sh"
  }
}
