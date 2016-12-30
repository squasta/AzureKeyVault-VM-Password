#==================================================================================================
#= Demo Azure Key Vault - Stanislas Quastana - https://stanislas.io @squastana
#= English version 
#= purpose of this script is to create an Azure Key Vault and a secret inside this vault
#= this secret is a password that will be used during a Windows VM deployment with a ARM template
#= All you need is to to change name of Azure Subscription below 
#=
#= French version - objectifs :
#= objectif de ce script : creer un Azure key Vault et un secret dans ce Vault
#= definir dans ce vault un secret, ici un mot de passe qui sera utilise pour deployer une 
#= VM Windows à partir d'un modele ARM
#= Vous avez besoin de l'ID de votre abonnement Azure
#====================================================================================================

#-- you need to log in to Azure in PowerShell
#-- Se logguer dans Azure en PowerShell
Login-AzureRMAccount
Get-AzureRmSubscription
Select-AzureRMSubscription -subscriptionname "<Name of Azure subscription>"

#-- Create a Resource Group for Azure Key Vault
#--- Creer un Resource Group pour l Azure Key Vault 
New-AzureRmResourceGroup --Name 'RG-AzureKeyVaultStan' --Location 'North Europe'

#-- Create a Azure Key Vault (it's now also possible using portal.azure.com)
#-- Creer un Azure key Vault (Possible desormais aussi via le portail)
#--  plus d'info / more info : https://docs.microsoft.com/en-us/powershell/resourcemanager/azurerm.keyvault/v1.1.11/New-AzureRmKeyVault?redirectedfrom=msdn
#------------------------------------------------------------------------------------------
New-AzureRmKeyVault -VaultName 'AzureKeyVaultStan' -ResourceGroupName 'RG-AzureKeyVaultStan' -Location 'North Europe' -EnabledForDeployment -EnabledForDiskEncryption -EnabledForTemplateDeployment

#-- Create a Secret and store it in Azure Key Vault
#--- Creer un secret et le stocker dans l'Azure Key Vault ----
$Secret = ConvertTo-SecureString -String 'Password1234' -AsPlainText -Force 
Set-AzureKeyVaultSecret -VaultName 'AzureKeyVaultStan' -Name 'Password2017VM' -SecretValue $Secret

#-- Create a Resource Group for VM deployment
#-- Creer un resource Group pour deployer la VM
New-AzureRmResourceGroup -Name RG-TEST -Location "North Europe"

#-- Test before deployment
#-- Tester avant de deployer ---
Test-AzureRmResourceGroupDeployment -ResourceGroupName RG-Test -TemplateFile .\azuredeployVMPassVault.json -TemplateParameterFile .\azuredeployVMPassVault.parameters.json

#-- Deploy a VM with its password stored in Azure Key Vault using an ARM Template and a parameter file that includes path to secret in Azure key Vault
#-- Deployer la VM avec mot de passe stocke dans Azure Key Vault a partir d'un modele ARM et d'un fichier de parametre contenant le chemin vers le secret dans le Vault
New-AzureRmResourceGroupDeployment -ResourceGroupName RG-Test -TemplateFile .\azuredeployVMPassVault.json -TemplateParameterFile .\azuredeployVMPassVault.parameters.json

#-- To destroy everything / Tout nettoyer
# Remove-AzureRmResourceGroup -name "RG-AzureKeyVaultStan"
# Remove-AzureRmResourceGroup -name "RG-TEST"





