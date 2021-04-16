#!/bin/bash

. ../envs-staging.sh

#FOLDERS_REVERSE=("roles" "aks")
#FOLDERS_REVERSE=("log" "dns" "vnet" "nsg" "acr" "rg")
FOLDERS_REVERSE=("roles" "aks" "bastion" "gateway" "log" "dns" "vnet" "nsg" "acr" "rg")

echo "----- Terraform Destroy -----"

for folder in "${FOLDERS_REVERSE[@]}"
do
  echo "---------------------------"
  echo "Terraform destroying module $folder"
  echo "---------------------------"
  cd ./$folder
  terraform destroy --auto-approve
  cd ..
  echo " "
done