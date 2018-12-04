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

# Cosmos db
# NOTE: Account Name can only contain lower-case characters, numbers and the `-` character.
# https://www.terraform.io/docs/providers/azurerm/r/cosmosdb_account.html
resource "azurerm_cosmosdb_account" "default" {
  name                = "${local.base_safe_name}-cosmos1"
  location            = "Australia East"
  resource_group_name = "${azurerm_resource_group.default.name}"
  offer_type          = "Standard"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location = "Australia Southeast"
    failover_priority = 0
  }

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

# First App Service
# NOTE: The provided name here will be used as the URL address, so ensure it is unique per environment
resource "azurerm_app_service" "webapp1" {
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

# Second App Service
# NOTE: The provided name here will be used as the URL address, so ensure it is unique per environment
resource "azurerm_app_service" "webapp2" {
  name                = "${local.base_name}-webapp2"
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
