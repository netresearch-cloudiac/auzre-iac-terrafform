# Azure Infrastructure as Code using Terraform
This repository coonsists for the Azure Terrafrom template for standard infrastructure patterns

## Repository branch structure
- main    --> production branch (protected)
- develop --> development branch where developer branches are merged for staging and testing
- [user branch] --> developers will create their own branch to develop/patch and raise a pull request to merge to develop branch

## Templates

| Name | Description | Components | Status |
|----|----|----|----|
| common-mgt | common services for management of the Azure cloud | Storage - Terraform remote state, KeyVault | Inprogress|
| vnet-structre | vnet for the azure environment | VNETs, peerings | Not started|

## Terraform Setup

### Service Principal
- Create a service pricipal for automating the Azure Infra setup

### Enviroment Variable setup
- Setup below enviroment variables to connecting to Azure using service principal


# References
## Github actions
- Terraform Github actions offical repo - https://github.com/hashicorp/setup-terraform
- Terraform GitHub Actions Examples - https://github.com/xsalazar/terraform-github-actions-example
- How to use enviroment secrets in action - [Popular GitHub Repos by Language](https://github.com/pied-piper-inc/build-2021)
