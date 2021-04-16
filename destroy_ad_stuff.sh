#set the company name
export COMPANY_NAME=acmecoorp
#set the registered domain
export AAD_REGISTERED_DOMAIN=@snakesondagmail.onmicrosoft.com

echo "destroying  Active Directory things"

az ad user delete --id devops1${AAD_REGISTERED_DOMAIN}
az ad user delete --id developer1${AAD_REGISTERED_DOMAIN}
az ad user delete --id enduser1${AAD_REGISTERED_DOMAIN}

az ad group delete --group devops
az ad group delete --group developer
az ad group delete --group user

az ad sp delete --id http://devops-acmecoorp
az ad app delete --id https://acmecoorp-AD-Server
#az ad app delete --id acmecoorp-AD-Client

