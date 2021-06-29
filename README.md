# Azure Infrastructure as Code using Terraform
This repository coonsists for the Azure Terrafrom template for standard infrastructure patterns

## Repository branch structure
- main    --> production branch (protected)
- develop --> development branch where developer branches are merged for staging and testing
- <user branch> --> developers will create their own branch to develop/patch and raise a pull request to merge to develop branch

## Templates

| Name | Description | Components | Status |
|----|----|----|----|
| common-mgt | common services for management of the Azure cloud | Storage - Terraform remote state, KeyVault | Inprogress|
| vnet-structre | vnet for the azure environment | VNETs, peerings | Not started|


