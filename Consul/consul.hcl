data_dir  = "/opt/consul"
log_level = "DEBUG"

datacenter = "firecell"

server = true

bootstrap_expect = 1
ui               = true

bind_addr   = "0.0.0.0"
client_addr = "0.0.0.0"

ports {
  http = 8500
  grpc = 8502
}

connect {
  enabled = true
}

advertise_addr                = "192.168.1.244"
enable_central_service_config = true

ui_config {
  enabled = true

}