vms = {
  "platipus-atlantis" = {
    machine_type             = "e2-medium"
    image                    = "debian-cloud/debian-12"
    disk_size_gb             = 30
    is_spot                  = false
    add_public_ip            = true
    max_run_duration_seconds = null
    subnet_name              = "subnet-01"
    startup_script_path      = "scripts/startup.sh"
  },                                                                                                                                                                                                 
      "platipus-test-vm" = {                                                                                                                                                                             
        machine_type             = "e2-micro"                                                                                                                                                            
        image                    = "debian-cloud/debian-12"                                                                                                                                              
        disk_size_gb             = 10                                                                                                                                                                    
        is_spot                  = true                                                                                                                                                                 
        add_public_ip            = false                                                                                                                                                                 
        max_run_duration_seconds = 180 # 30 mins                                                                                                                                                        
        subnet_name              = "subnet-01"                                                                                                                                                           
        # startup_script_path      = "scripts/startup.sh"                                                                                                                                                  
      }               
}
