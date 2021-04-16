# azure_buildstaging
this is the basic setup for a buildstaging subscription on azure:

#First Steps:
- install python3 e AZ CLI and Terraform

    `this have a different setup for each OS so suit yourself`
    
- run AZ login and follow the instructions

    `az login --use-device-code`

- export the name of the account that you wanna use
    `export COMPANY_NAME=acme`   
    `export RESOURCE_GROUP=devops-$COMPANY_NAME`
    `export SERVICE_PRINCIPAL=devops-$COMPANY_NAME`
    `export STORAGE_ACCOUNT=devops${COMPANY_NAME}stg`

- export the id of the desired Subscription
 
    `export SUBSCRIPTION_ID=$(az account show -s='${COMPANY_NAME}' |grep id |  cut -d'"' -f 4)`
        
- create the DevOps resource group: on this example we are using the Region: eastus (East of USA)

    `az group create -l eastus -n $RESOURCE_GROUP`
    
- create the storage account for holding the terraform state. the Name you Choose for the storage account needs to be unique

    `az storage account create -n $STORAGE_ACCOUNT -l eastus -g $RESOURCE_GROUP --sku Standard_LRS`

- export the STORAGE_KEY for the account that you have created:

    `export STORAGE_KEY=$(az storage account keys list -g $RESOURCE_GROUP -n $STORAGE_ACCOUNT | grep value -m 1| cut -d'"' -f 4 )` 

- create the storage container on the account previously made:

    `az storage container create -n tfstate --account-name $RESOURCE_GROUP --account-key $STORAGE_KEY`

- create the service-principal and get the password and tenant info 

    `export OUTPUT_JSON=$(az ad sp create-for-rbac --name="$SERVICE_PRINCIPAL" --role="Contributor" --scopes="/subscriptions/${SUBSCRIPTION_ID}")`
 
    `export ARM_CLIENT_ID=$(echo $OUTPUT_JSON |grep "appId" |  cut -d'"' -f 4)`
    
    `export ARM_CLIENT_SECRET=$(echo $OUTPUT_JSON |grep "password" |  cut -d'"' -f 4)`
    
    `export ARM_SUBSCRIPTION_ID=$SUBSCRIPTION_ID`
     
    `export ARM_TENANT_ID=$(echo $OUTPUT_JSON |grep tenant |  cut -d'"' -f 4)`
    
    `export TF_VAR_client_id=$ARM_CLIENT_ID`
    
    `export TF_VAR_client_secret=$ARM_CLIENT_SECRET`

- Create the AD groups
    
    `export TF_VAR_developers_group_id=$(az ad group create --display-name developers --mail-nickname developers --query objectId -o tsv)`
    
    `export TF_VAR_devops_id=$(az ad group create --display-name devops --mail-nickname devops --query objectId -o tsv)` 

- Run the creation of the rg 


    `cd ../rg`
    `terraform init`
    `terraform apply `

- Run the creation of the log 

    `cd ../log`
    `terraform init`
    `terraform apply `
    
- Run the creation of the vnet 

    `cd ../vnet`
    `terraform init`
    `terraform apply `

    
- run terraform planning tool

    `terraform plan`

- if everything is ok with the planning run the terraform apply and verify the state of the creation process
    
    
- export the Kubeconfig and start using the Kubectl to improve things
`echo "$(terraform output kube_config)" > ./azurek8s`
`export KUBECONFIG=./azurek8s`
`kubectl get nodes`