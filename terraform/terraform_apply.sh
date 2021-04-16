#!/bin/bash

#FOLDERS=("rg" "acr" "nsg" "vnet" "dns" "log")
#FOLDERS=("rg" "acr" "nsg" "vnet" "dns" "log" "aks" "roles")
FOLDERS=("rg" "acr" "nsg" "vnet" "dns" "log" "gateway" "aks" "roles")

echo "----- Terraform Apply -----"

for folder in "${FOLDERS[@]}"
do
  echo "---------------------------"
  echo "Terraform applying module $folder"
  echo "---------------------------"
  cd ./$folder
  terraform apply --auto-approve
  cd ..
  echo " "
done