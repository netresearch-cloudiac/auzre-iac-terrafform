data "cloudinit_config" "linux-vm" {
    gzip = true
    base64_encode = true

    part {
      filename = "vmstart-cloud-cloudconfig.yaml"
      content_type = "text/cloud-config"

      content = file("vmstart-cloud-cloudconfig.yaml")
    } 
}