# Azure Terraform Samples

This repository contains some example Azure Terraform scripts that use Octopus as their CD tool. Because of this, many of the variables are in Octopus format (i.e. *#{AzureResourceGroup}* instead of *${AzureResourceGroup}*) with the assumption that they will be in-line replaced by Octopus during a deployment.


The following samples currently exist:

### Hybrid Web+Sql deployment

This example is used in situations where the Azure deployment needs to communicate with on-premise software via a Hybrid Relay.

The following Azure solutions are installed:  

* Resource Group
* Application Insights
* App Service (+Plan)
* Sql Server
    * Sql Server database
* Key Vault
* Storage Account
    * Storage Container
    * Blob Storage
* Hybrid Relay

All resources follow a consistent naming scheme across your Octopus environments.
