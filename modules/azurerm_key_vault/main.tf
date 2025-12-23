data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  for_each                    = var.key_vaults
  name                        = each.value.kv_name
  location                    = each.value.location
  resource_group_name         = each.value.rg_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Backup",
      "Delete",
      "Get",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Set"
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

locals {
  vm_secrets = flatten([
    for kv_key, kv in var.key_vaults : [
      for vm_name in kv.vm_names : {
        kv_key   = kv_key
        vm_name  = vm_name
        username = kv.vm_usernames[vm_name]
        password = kv.vm_passwords[vm_name]
      }
    ]
  ])
}

resource "azurerm_key_vault_secret" "vm_username" {
  for_each = {
    for s in local.vm_secrets :
    "${s.kv_key}-${s.vm_name}-username" => s
  }

  name         = "${each.value.vm_name}-username"
  value        = each.value.username
  key_vault_id = azurerm_key_vault.kv[each.value.kv_key].id
}

resource "azurerm_key_vault_secret" "vm_password" {
  for_each = {
    for s in local.vm_secrets :
    "${s.kv_key}-${s.vm_name}-password" => s
  }

  name         = "${each.value.vm_name}-password"
  value        = each.value.password
  key_vault_id = azurerm_key_vault.kv[each.value.kv_key].id
}