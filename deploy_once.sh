#!/bin/bash

gitrepo=https://github.com/kaiekkrin/npc.git
resourcegroup=pf2npcMasterResourceGroup
webappname=pf2npc$RANDOM

# Create a resource group.
az group create --location westeurope --name $resourcegroup

# Create an App Service plan in `FREE` tier.
az appservice plan create --name $webappname --resource-group $resourcegroup --sku FREE

# Create a web app.
az webapp create --name $webappname --resource-group $resourcegroup --plan $webappname

# Deploy code from a public GitHub repository. 
az webapp deployment source config --name $webappname --resource-group $resourcegroup \
--repo-url $gitrepo --branch master --manual-integration

# Copy the result of the following command into a browser to see the web app.
echo http://$webappname.azurewebsites.net
