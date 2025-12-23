variable "rgs" {
  type = map(object({
    name       = string
    location   = string
    managed_by = string
    tags       = map(string)
  }))
}

variable "networks" {}
variable "public_ips" {}
variable "key_vaults" {
  
}
variable "vms" {
  type = map(object(
    {
      nic_name               = string
      location               = string
      rg_name                = string
      vnet_name              = string
      subnet_name            = string
      pip_name               = string
      vm_name                = string
      size                   = string
      kv_name                = optional(string)
      admin_username         = optional(string)
      admin_password         = optional(string)
      source_image_reference = map(string)
    }
  ))
}