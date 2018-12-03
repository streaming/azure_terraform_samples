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