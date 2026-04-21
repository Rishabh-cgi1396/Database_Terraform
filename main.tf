terraform {
  required_version = ">= 1.5.0"

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstateprod12345"
    container_name       = "tfstate"
    key                  = "sql-dev.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

# VARIABLES (inline)
variable "resource_group" {}
variable "location" { default = "Central India" }
variable "sql_server_name" {}
variable "db_name" {}
variable "admin_user" {}
variable "admin_password" {
  sensitive = true
}
variable "start_ip" {}
variable "end_ip" {}
variable "principal_id" {}

# RESOURCES
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location
}

resource "azurerm_mssql_server" "sql" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.admin_user
  administrator_login_password = var.admin_password
}

resource "azurerm_mssql_database" "db" {
  name      = var.db_name
  server_id = azurerm_mssql_server.sql.id
  sku_name  = "S0"
}

resource "azurerm_mssql_firewall_rule" "fw" {
  name             = "allow-access"
  server_id        = azurerm_mssql_server.sql.id
  start_ip_address = var.start_ip
  end_ip_address   = var.end_ip
}

resource "azurerm_key_vault" "kv" {
  name                = "${var.sql_server_name}-kv"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

resource "azurerm_key_vault_access_policy" "policy" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.principal_id

  secret_permissions = ["Get", "List", "Set"]
}
