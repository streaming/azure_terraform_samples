# Configure the Azure Provider and the authentication details.
provider "azurerm" {
  client_id       = "#{AzureClientId}"
  client_secret   = "#{AzureClientSecret}"
  subscription_id = "#{AzureSubscriptionId}"
  tenant_id       = "#{AzureTenantId}"
}

# Configure some local values that will be common across most of the resources
locals {
  # A consistent base name that resources can use.
  base_name = "${lower("${var.resource_group_name}-${var.resource_group_descriptor}-${var.environment_tag}")}"

  # base_safe_name provides us with a lower case version of base_name where dashes have been stripped to conform to 
  # some Azure naming requirements.
  base_safe_name = "${var.safe_resource_name == "auto" ? replace(local.base_name, "-", "") : var.safe_resource_name}"
}

# Output the base names created above
output "display_base_name" {
  value = "${local.base_name}"
}

output "display_base_safe_name" {
  value = "${local.base_safe_name}"
}

# Root resource group for storing all of the resources.
resource "azurerm_resource_group" "default" {
  name     = "${local.base_name}"
  location = "${var.location}"

  tags {
    environment = "${var.environment_tag}"
  }
}

# Application insights for our monitoring solution
resource "azurerm_application_insights" "default" {
  name                = "${local.base_name}-insights1"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  application_type    = "Web"
}

# App Service Plan to host our Azure applications
resource "azurerm_app_service_plan" "default" {
  name                = "${local.base_name}-plan1"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"

  sku {
    tier = "${var.app_service_plan_pricing_tier}"
    size = "${var.app_service_plan_sku_size}"
  }

  tags {
    environment = "${var.environment_tag}"
  }
}

# App Service
# NOTE: The provided name here will be used as the URL address, so ensure it is unique per environment
resource "azurerm_app_service" "default" {
  name                = "${local.base_name}-webapp1"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  app_service_plan_id = "${azurerm_app_service_plan.default.id}"

  site_config {
    dotnet_framework_version = "v4.0"
  }

  app_settings {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = "${azurerm_application_insights.default.instrumentation_key}"
  }

  tags {
    environment = "${var.environment_tag}"
  }
}

# Sql Server
resource "azurerm_sql_server" "default" {
  name                         = "${local.base_name}-sqlserver1"
  resource_group_name          = "${azurerm_resource_group.default.name}"
  location                     = "${var.location}"
  version                      = "12.0"
  administrator_login          = "${var.sql_server_admin_username}"
  administrator_login_password = "${var.sql_server_admin_password}"

  tags {
    environment = "${var.environment_tag}"
  }
}

# Sql Server Database
resource "azurerm_sql_database" "default" {
  name                = "${local.base_name}-sqldatabase1"
  resource_group_name = "${azurerm_resource_group.default.name}"
  location            = "${var.location}"
  server_name         = "${azurerm_sql_server.default.name}"

  tags {
    environment = "${var.environment_tag}"
  }
}

# Key Vault
resource "azurerm_key_vault" "default" {
  name                = "${local.base_safe_name}-kv1"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"

  sku {
    name = "standard"
  }

  tenant_id = "${var.keyvault_tenantid}"

  access_policy {
    tenant_id = "${var.keyvault_tenantid}"
    object_id = "${var.keyvault_objectid}"

    key_permissions = [
      "get",
    ]

    secret_permissions = [
      "get",
    ]
  }

  enabled_for_disk_encryption = true

  tags {
    environment = "${var.environment_tag}"
  }
}

# Storage account
resource "azurerm_storage_account" "default" {
  name                     = "${local.base_safe_name}stgacc1"
  resource_group_name      = "${azurerm_resource_group.default.name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags {
    environment = "${var.environment_tag}"
  }
}

resource "azurerm_storage_container" "default" {
  name                  = "${local.base_name}stg1"
  resource_group_name   = "${azurerm_resource_group.default.name}"
  storage_account_name  = "${azurerm_storage_account.default.name}"
  container_access_type = "private"
}

resource "azurerm_storage_blob" "default" {
  name                   = "${local.base_name}-container1"
  resource_group_name    = "${azurerm_resource_group.default.name}"
  storage_account_name   = "${azurerm_storage_account.default.name}"
  storage_container_name = "${azurerm_storage_container.default.name}"

  type = "page"
  size = 5120
}

# Relay
resource "azurerm_relay_namespace" "default" {
  name                = "${local.base_safe_name}relay1"
  location            = "${azurerm_resource_group.default.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"

  sku {
    name = "Standard"
  }

  tags {
    source = "${var.environment_tag}"
  }
}
