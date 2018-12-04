# Specify Azure blob storage backend for state management
terraform {
  backend "azurerm" {
    storage_account_name = "#{AzureStorageAccountName}"
    container_name       = "#{AzureStorageContainerName}"
    key                  = "#{AzureResourceGroup}.#{AzureResourceGroupDescriptor}.terraform.#{Environment}.tfstate"
    access_key           = "#{AzureAccessKey}"
  }
}
