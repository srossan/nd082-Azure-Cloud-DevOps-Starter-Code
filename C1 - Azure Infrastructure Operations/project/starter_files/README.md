# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
Requirements:
-------------
Connect to Azure environment with your account, az login
Create SSH keys, type RSA and 2048 bits (at least) on host where packer and terraform command will be run from
Create a resource group for packer, in Azure, call it udacity-templates-rg

Define environment variables:
- ARM_CLIENT_ID="value of your client ID"
- ARM_CLIENT_SECRET="value of the client secret"
- ARM_TENANT_ID="value of the client tenand"
- ARM_SUBSCRIPTION_ID="value of your azure subscription ID"

Targetted region is: eastus
Be sure to set a tag called "environment" to each new resource you create.
There is an active policy which won't allow to create any resources without appropriate tagging.

======
Packer
======
Define and Create a packer image, (to be used later in the terraform manifest).
use server.json for definition

run "packer build server.json"
Record details about image:
- name
- resource_group_name (different from main.tf)

These infos will be used in the Terraform main.tf file.

=========
Terraform
=========
update/modify main.tf for Infrastructure as Code (IaC)
set name for packer-image with name and resource_group_name

Variables are stored and defined in vars.tf:
- location (region)
- prefix (project prefix)
- tagging (environment)
- instance (number of instances, min=2 and/or max=5)
- username (linux user)


Run terraform cli commands for building the environment within Microsoft Cloud (Azure).

### Output
Packer Output:
--------------

$ packer build server.json 
azure-arm: output will be in this color.

==> azure-arm: Running builder ...
==> azure-arm: Getting tokens using client secret
==> azure-arm: Getting tokens using client secret
    azure-arm: Creating Azure Resource Manager (ARM) client ...
==> azure-arm: WARNING: Zone resiliency may not be supported in East US, checkout the docs at https://docs.microsoft.com/en-us/azure/availability-zones/
==> azure-arm: Creating resource group ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-s2j47mggc2'
==> azure-arm:  -> Location          : 'East US'
==> azure-arm:  -> Tags              :
==> azure-arm:  ->> environment : Artifacts
==> azure-arm:  ->> template : Ubuntu1804
==> azure-arm: Validating deployment template ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-s2j47mggc2'
==> azure-arm:  -> DeploymentName    : 'pkrdps2j47mggc2'
==> azure-arm: Deploying deployment template ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-s2j47mggc2'
==> azure-arm:  -> DeploymentName    : 'pkrdps2j47mggc2'
==> azure-arm: Getting the VM's IP address ...
==> azure-arm:  -> ResourceGroupName   : 'pkr-Resource-Group-s2j47mggc2'
==> azure-arm:  -> PublicIPAddressName : 'pkrips2j47mggc2'
==> azure-arm:  -> NicName             : 'pkrnis2j47mggc2'
==> azure-arm:  -> Network Connection  : 'PublicEndpoint'
==> azure-arm:  -> IP Address          : '13.90.32.24'
==> azure-arm: Waiting for SSH to become available...
==> azure-arm: Connected to SSH!
==> azure-arm: Provisioning with shell script: /tmp/packer-shell726339049
==> azure-arm: + echo Hello, World!
==> azure-arm: + nohup busybox httpd -f -p 80
==> azure-arm: Querying the machine's properties ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-s2j47mggc2'
==> azure-arm:  -> ComputeName       : 'pkrvms2j47mggc2'
==> azure-arm:  -> Managed OS Disk   : '/subscriptions/ARM_SUBSCRIPTION_ID/resourceGroups/PKR-RESOURCE-GROUP-S2J47MGGC2/providers/Microsoft.Compute/disks/pkross2j47mggc2'
==> azure-arm: Querying the machine's additional disks properties ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-s2j47mggc2'
==> azure-arm:  -> ComputeName       : 'pkrvms2j47mggc2'
==> azure-arm: Powering off machine ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-s2j47mggc2'
==> azure-arm:  -> ComputeName       : 'pkrvms2j47mggc2'
==> azure-arm: Capturing image ...
==> azure-arm:  -> Compute ResourceGroupName : 'pkr-Resource-Group-s2j47mggc2'
==> azure-arm:  -> Compute Name              : 'pkrvms2j47mggc2'
==> azure-arm:  -> Compute Location          : 'East US'
==> azure-arm:  -> Image ResourceGroupName   : 'udacity-templates-rg'
==> azure-arm:  -> Image Name                : 'UbuntuImage-1804'
==> azure-arm:  -> Image Location            : 'East US'
==> azure-arm: Deleting resource group ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-s2j47mggc2'
==> azure-arm: 
==> azure-arm: The resource group was created by Packer, deleting ...
==> azure-arm: Deleting the temporary OS disk ...
==> azure-arm:  -> OS Disk : skipping, managed disk was used...
==> azure-arm: Deleting the temporary Additional disk ...
==> azure-arm:  -> Additional Disk : skipping, managed disk was used...
==> azure-arm: Removing the created Deployment object: 'pkrdps2j47mggc2'
==> azure-arm: ERROR: -> ResourceGroupNotFound : Resource group 'pkr-Resource-Group-s2j47mggc2' could not be found.
==> azure-arm:
Build 'azure-arm' finished.

==> Builds finished. The artifacts of successful builds are:
--> azure-arm: Azure.ResourceManagement.VMImage:

OSType: Linux
ManagedImageResourceGroupName: udacity-templates-rg
ManagedImageName: UbuntuImage-1804
ManagedImageId: /subscriptions/ARM_SUBSCRIPTION_ID/resourceGroups/udacity-templates-rg/providers/Microsoft.Compute/images/UbuntuImage-1804
ManagedImageLocation: East US


Terraform Output:
-----------------

Plan: 16 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

azurerm_resource_group.udacity: Creating...
azurerm_resource_group.udacity: Creation complete after 1s [id=/subscriptions/ARM_SUBSCRIPTION_ID/resourceGroups/udacity-rg]
azurerm_public_ip.pip: Creating...
azurerm_availability_set.udacity: Creating...
azurerm_virtual_network.udacity: Creating...
azurerm_availability_set.udacity: Creation complete after 3s [id=/subscriptions/ARM_SUBSCRIPTION_ID/resourceGroups/udacity-rg/providers/Microsoft.Compute/availabilitySets/udacity-avset]
azurerm_public_ip.pip: Creation complete after 4s [id=/subscriptions/ARM_SUBSCRIPTION_ID/resourceGroups/udacity-rg/providers/Microsoft.Network/publicIPAddresses/udacity-pip]
azurerm_lb.udacity: Creating...
azurerm_lb.udacity: Creation complete after 4s [id=/subscriptions/ARM_SUBSCRIPTION_ID/resourceGroups/udacity-rg/providers/Microsoft.Network/loadBalancers/udacity-lb]
azurerm_lb_nat_rule.udacity: Creating...
azurerm_lb_backend_address_pool.udacity: Creating...
azurerm_lb_backend_address_pool.udacity: Creation complete after 2s [id=/subscriptions/ARM_SUBSCRIPTION_ID/resourceGroups/udacity-rg/providers/Microsoft.Network/loadBalancers/udacity-lb/backendAddressPools/BackEndAddressPool]
azurerm_virtual_network.udacity: Still creating... [10s elapsed]
azurerm_lb_nat_rule.udacity: Creation complete after 3s [id=/subscriptions/ARM_SUBSCRIPTION_ID/resourceGroups/udacity-rg/providers/Microsoft.Network/loadBalancers/udacity-lb/inboundNatRules/HTTPSAccess]
azurerm_virtual_network.udacity: Creation complete after 15s [id=/subscriptions/ARM_SUBSCRIPTION_ID/resourceGroups/udacity-rg/providers/Microsoft.Network/virtualNetworks/udacity-network]
azurerm_subnet.internal: Creating...
azurerm_subnet.internal: Creation complete after 6s [id=/subscriptions/ARM_SUBSCRIPTION_ID/resourceGroups/udacity-rg/providers/Microsoft.Network/virtualNetworks/udacity-network/subnets/internal]
azurerm_network_interface.udacity[1]: Creating...
azurerm_network_security_group.webserver: Creating...
azurerm_network_interface.udacity[0]: Creating...
azurerm_network_security_group.ssh: Creating...
azurerm_network_security_group.webserver: Creation complete after 4s [id=/subscriptions/ARM_SUBSCRIPTION_ID/resourceGroups/udacity-rg/providers/Microsoft.Network/networkSecurityGroups/webserver]
azurerm_network_interface.udacity[0]: Creation complete after 4s [id=/subscriptions/ARM_SUBSCRIPTION_ID/resourceGroups/udacity-rg/providers/Microsoft.Network/networkInterfaces/udacity-nic0]
azurerm_network_security_group.ssh: Creation complete after 4s [id=/subscriptions/ARM_SUBSCRIPTION_ID/resourceGroups/udacity-rg/providers/Microsoft.Network/networkSecurityGroups/ssh]
azurerm_network_interface.udacity[1]: Creation complete after 7s [id=/subscriptions/ARM_SUBSCRIPTION_ID/resourceGroups/udacity-rg/providers/Microsoft.Network/networkInterfaces/udacity-nic1]
azurerm_network_interface_backend_address_pool_association.udacity[0]: Creating...
azurerm_network_interface_backend_address_pool_association.udacity[1]: Creating...
azurerm_linux_virtual_machine.udacity[0]: Creating...
azurerm_linux_virtual_machine.udacity[1]: Creating...
azurerm_network_interface_backend_address_pool_association.udacity[1]: Creation complete after 1s [id=/subscriptions/ARM_SUBSCRIPTION_ID/resourceGroups/udacity-rg/providers/Microsoft.Network/networkInterfaces/udacity-nic1/ipConfigurations/primary|/subscriptions/ARM_SUBSCRIPTION_ID/resourceGroups/udacity-rg/providers/Microsoft.Network/loadBalancers/udacity-lb/backendAddressPools/BackEndAddressPool]
azurerm_network_interface_backend_address_pool_association.udacity[0]: Creation complete after 1s [id=/subscriptions/ARM_SUBSCRIPTION_ID/resourceGroups/udacity-rg/providers/Microsoft.Network/networkInterfaces/udacity-nic0/ipConfigurations/primary|/subscriptions/ARM_SUBSCRIPTION_ID/resourceGroups/udacity-rg/providers/Microsoft.Network/loadBalancers/udacity-lb/backendAddressPools/BackEndAddressPool]
azurerm_linux_virtual_machine.udacity[0]: Still creating... [10s elapsed]
azurerm_linux_virtual_machine.udacity[1]: Still creating... [10s elapsed]
azurerm_linux_virtual_machine.udacity[0]: Still creating... [20s elapsed]
azurerm_linux_virtual_machine.udacity[1]: Still creating... [20s elapsed]
azurerm_linux_virtual_machine.udacity[0]: Still creating... [30s elapsed]
azurerm_linux_virtual_machine.udacity[1]: Still creating... [30s elapsed]
azurerm_linux_virtual_machine.udacity[0]: Still creating... [40s elapsed]
azurerm_linux_virtual_machine.udacity[1]: Still creating... [40s elapsed]
azurerm_linux_virtual_machine.udacity[0]: Still creating... [50s elapsed]
azurerm_linux_virtual_machine.udacity[1]: Still creating... [50s elapsed]
azurerm_linux_virtual_machine.udacity[0]: Still creating... [1m0s elapsed]
azurerm_linux_virtual_machine.udacity[1]: Still creating... [1m0s elapsed]
azurerm_linux_virtual_machine.udacity[0]: Still creating... [1m10s elapsed]
azurerm_linux_virtual_machine.udacity[1]: Still creating... [1m10s elapsed]
azurerm_linux_virtual_machine.udacity[0]: Still creating... [1m20s elapsed]
azurerm_linux_virtual_machine.udacity[1]: Still creating... [1m20s elapsed]
azurerm_linux_virtual_machine.udacity[0]: Still creating... [1m30s elapsed]
azurerm_linux_virtual_machine.udacity[1]: Still creating... [1m30s elapsed]
azurerm_linux_virtual_machine.udacity[0]: Still creating... [1m40s elapsed]
azurerm_linux_virtual_machine.udacity[1]: Still creating... [1m40s elapsed]
azurerm_linux_virtual_machine.udacity[1]: Creation complete after 1m40s [id=/subscriptions/ARM_SUBSCRIPTION_ID/resourceGroups/udacity-rg/providers/Microsoft.Compute/virtualMachines/udacity-vm1]
azurerm_linux_virtual_machine.udacity[0]: Still creating... [1m50s elapsed]
azurerm_linux_virtual_machine.udacity[0]: Still creating... [2m0s elapsed]
azurerm_linux_virtual_machine.udacity[0]: Still creating... [2m10s elapsed]
azurerm_linux_virtual_machine.udacity[0]: Still creating... [2m20s elapsed]
azurerm_linux_virtual_machine.udacity[0]: Still creating... [2m30s elapsed]
azurerm_linux_virtual_machine.udacity[0]: Still creating... [2m40s elapsed]
azurerm_linux_virtual_machine.udacity[0]: Creation complete after 2m40s [id=/subscriptions/ARM_SUBSCRIPTION_ID/resourceGroups/udacity-rg/providers/Microsoft.Compute/virtualMachines/udacity-vm0]

Apply complete! Resources: 16 added, 0 changed, 0 destroyed.

