# The name of the resource group
variable "resource_group_name" {
  type    = "string"
  default = "#{AzureResourceGroup}"
}

# Short descriptor of the project
variable "resource_group_descriptor" {
  type    = "string"
  default = "#{AzureResourceGroupDescriptor}"
}

# Optional safe resource name for resources that cannot contain non alpha numeric characters etc.
# Note: If this is set as the value "auto", then the value will be calculated for you with base_safe_name inside deployment.tf
variable "safe_resource_name" {
  type    = "string"
  default = "#{AzureSafeResourceName}"
}

variable "environment_tag" {
  type    = "string"
  default = "#{Environment}"
}

# The default location for resources
# Note: Some resources will not use this value as they cannot be defined there
variable "location" {
  type    = "string"
  default = "#{AzureLocation}"
}

# The name of the App Service.
variable "app_service_name" {
  type    = "string"
  default = "#{AppServiceName}"
}

# The App Service SKU Size
variable "app_service_plan_sku_size" {
  type    = "string"
  default = "S1"     # B1 | S1 | ...
}

# The App Service Pricing Tier
variable "app_service_plan_pricing_tier" {
  type    = "string"
  default = "Free"   # Free | Basic | ...
}

# Sql Server username
variable "sql_server_admin_username" {
  type    = "string"
  default = "mradministrator"
}

# Sql Server password
variable "sql_server_admin_password" {
  type    = "string"
  default = "thisIsDog11"
}

# Key Vault tenant id -- The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault
variable "keyvault_tenantid" {
  type    = "string"
  default = "#{AzureTenantId}"
}

# Key Vault object id -- The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault
variable "keyvault_objectid" {
  type    = "string"
  default = "#{AzureTenantId}"
}
