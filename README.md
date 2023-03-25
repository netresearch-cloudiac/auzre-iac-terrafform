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

## Clone local copy
- The repository uses submodules for ansible playbooks so use below git cloning command to clone all the dependent modules
```shell
git clone --recurse-submodules https://github.com/netresearch-cloudiac/azure-iac-terraform.git
```

## Templates

| Name | Description | Components | Status |
|----|----|----|----|
| common-mgt | common services for management of the Azure cloud | Storage - Terraform remote state, KeyVault | Inprogress|
| vnet-structre | vnet for the azure environment | VNETs, peerings | Not started|
|[Tier4app](/04-slb2srv1reg) | One Loadbalancer with two web servers | one azure standard load balancer with two windows servers | In Progress|
|[VM & Network provisiioning](/99-training-files/) | VNET and Server provistioning with Terrafrom and configuration with cloud-init and Ansible | VNET, Two servers, startup config by cloud-init, Configration managememt by Ansible | Done|

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

## Terraform commands
```shell
terraform init
terraform plan
terraform apply
terraform destroy

# destrcoy specific resrouce 
terraform destroy --target azurerm_linux_virtual_machine.linux-vm2

```

## Azure cli commads
```shell

# List VM sizes in a region
az vm list-sizes --location "east us" --output table

# List VM images from a particular publisher
az vm image list --all --publisher Canonical -o table

# List VM extenstion filter to AADlogin
az vm extension image list -o tsv | sort -u | findstr AADLoginForWindows

```
# References
## Ubuntu skus
Ubuntu skus for use with terraform script

```shell
    source_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "18.04-LTS"
        version = "latest"
    }
    
    source_image_reference {
        publisher = "Canonical"
        offer = "0001-com-ubuntu-server-focal"
        sku = "20_04-lts"   
        version = "latest"
    }

    source_image_reference {
        publisher = "Canonical"
        offer = "0001-com-ubuntu-server-jammy"
        sku = "22_04-lts"   
        version = "latest"
    }
```

## Enable AAD login for VMs
- SSH auth with AAD - https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/auth-ssh
- Linux VM with AAD - https://learn.microsoft.com/en-us/azure/active-directory/devices/howto-vm-sign-in-azure-ad-linux
- Windows vm with AAD - https://learn.microsoft.com/en-us/azure/active-directory/devices/howto-vm-sign-in-azure-ad-windows

Prerequisties
- Add one of the roles below to user
    - Virtual Machine Administrator Login: Users who have this role assigned can log in to an Azure virtual machine with administrator privileges.
    - Virtual Machine User Login: Users who have this role assigned can log in to an Azure virtual machine with regular user privileges.

- enable 'SystemAssigned" managed identity

```shell
identity {
        type = "SystemAssigned"
    }
```
- add extensions

```shell
# Windows VM AAD extension
resource "azurerm_virtual_machine_extension" "windows-vm-aad" {
    name = "aad-extension"
    virtual_machine_id = azurerm_windows_virtual_machine.windows-vm.id
    publisher = "Microsoft.Azure.ActiveDirectory"
    type = "AADLoginForWindows"
    type_handler_version = "1.0"
    auto_upgrade_minor_version = true
}

# Linux VM AAD extension
resource "azurerm_virtual_machine_extension" "linux-vm-aad" {
    name = "aad-extension"
    virtual_machine_id = azurerm_linux_virtual_machine.linux-vm.id
    publisher = "Microsoft.Azure.ActiveDirectory"
    type = "AADSSHLoginForLinux"
    type_handler_version = "1.0"
    auto_upgrade_minor_version = true
}
```
- use below command to connect
```shell
az ssh vm --ip dblinuxvm01.eastus.cloudapp.azure.com
```


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

## Azure piplines
- Terraform Extension for Azure DevOps - https://github.com/microsoft/azure-pipelines-extensions/tree/master/Extensions/Terraform/Src
## Enterprise CI/CD
- Enterprise CI/CD Best Practices (3part series) - https://dev.to/kostiscodefresh/series/13231

## Cloud Operating Model
- How can organizations adopt the cloud operating model? - https://www.hashicorp.com/resources/what-is-cloud-operating-model-adoption
- Unlocking the Cloud Operating Model: People, Process, Tools - https://www.hashicorp.com/resources/unlocking-cloud-operating-model-people-process-tools
- AWS Events - Cloud Operating Models for Accelerated Transformation - Level 200 - https://www.youtube.com/watch?v=ksJ5_UdYIag
- AWS re:Invent 2020: Transform your organization’s culture with a Cloud Center of Excellence - https://www.youtube.com/watch?v=VN1vj0d3Z1Y

## Terraform template links
- Terraform on Azure documentation - https://docs.microsoft.com/en-us/azure/developer/terraform/
- Azure Terrafrom configuration templates - https://github.com/hashicorp/terraform-provider-azurerm/tree/main/examples
- Create an Azure VM cluster with loadbalancer with Terraform and HCL - https://docs.microsoft.com/en-us/azure/developer/terraform/create-vm-cluster-with-infrastructure
- example terraform outputs - https://github.com/Azure/terraform-azurerm-compute/blob/master/outputs.tf
- Muntiple subscriptions - https://jeffbrown.tech/terraform-azure-multiple-subscriptions/

## Automation and provision
- Cloud-Init With Terraform - https://www.phillipsj.net/posts/cloud-init-with-terraform/
- how to see cloud-init logs
``` shell
cat /var/log/cloud-init-output.log
```
- how to run ansible
``` shell
ansible-playbook vmplaybook.yaml
```
## Azure Networking VNET links
- How network security groups filter network traffic - https://docs.microsoft.com/en-us/azure/virtual-network/network-security-group-how-it-works
### Public IP address
- Public IP addresses Basic vs Standard - https://docs.microsoft.com/en-us/azure/virtual-network/public-ip-addresses
- IP Addresses pricing - https://azure.microsoft.com/en-au/pricing/details/ip-addresses/

## Load Balancer
- Loadbalancer-2VM - https://github.com/hashicorp/terraform-provider-azurerm/tree/main/examples/virtual-machines/virtual_machine/2-vms-loadbalancer-lbrules
