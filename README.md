# Azure Infrastructure as Code using Terraform
This repository coonsists for the Azure Terrafrom template for standard infrastructure patterns

## Repository branch structure
- main    --> production branch (protected)
- develop --> development branch where developer branches are merged for staging and testing
- [user branch] --> developers will create their own branch to develop/patch and raise a pull request to merge to develop branch

## Development Environment setup
- [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/azure-get-started)
- [Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Install Git](https://git-scm.com/downloads)
- [Install VScode](https://code.visualstudio.com/download) (and below extenstions)
    - Bracket pair colorizer 2
    - Azure terraform
    - Hashicorp terraform
    - git extension pack
    - Terraform azure autocomplete
    - Azure cli tools

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
```shell
ARM_CLIENT_ID
ARM_CLIENT_SECRET
ARM_SUBSCRIPTION_ID
ARM_TENANT_ID
```

# References
## Github actions
- Terraform Github actions offical repo - https://github.com/hashicorp/setup-terraform
- Terraform GitHub Actions Examples - https://github.com/xsalazar/terraform-github-actions-example
- How to use enviroment secrets in action - [Popular GitHub Repos by Language](https://github.com/pied-piper-inc/build-2021)
- Deploying to Azure using Terraform and Github Actions - https://www.blendmastersoftware.com/blog/deploying-to-azure-using-terraform-and-github-actions
- sharing variable between jobs - https://github.community/t/sharing-a-variable-between-jobs/16967/9
- Github Actions | Terraform | Github CI CD 
    - https://www.youtube.com/watch?v=JpnEjwTcczc
    - https://www.youtube.com/watch?v=36hY0-O4STg&t=1s
- Environment Scoped Secrets for GitHub Action Workflows 
    - https://dev.to/github/environment-scoped-secrets-for-github-action-workflows-337a
    - https://www.youtube.com/watch?v=tkKpGWMCG4Q
        - Github code for above video - https://github.com/pied-piper-inc/build-2021

## Enterprise CI/CD
- Enterprise CI/CD Best Practices (3part series) - https://dev.to/kostiscodefresh/series/13231

## Cloud Operating Model
- How can organizations adopt the cloud operating model? - https://www.hashicorp.com/resources/what-is-cloud-operating-model-adoption
- Unlocking the Cloud Operating Model: People, Process, Tools - https://www.hashicorp.com/resources/unlocking-cloud-operating-model-people-process-tools
- AWS Events - Cloud Operating Models for Accelerated Transformation - Level 200 - https://www.youtube.com/watch?v=ksJ5_UdYIag
- AWS re:Invent 2020: Transform your organization’s culture with a Cloud Center of Excellence - https://www.youtube.com/watch?v=VN1vj0d3Z1Y
