#!/bin/bash

FOLDERS=("rg" "acr" "nsg" "vnet" "dns" "log" "gateway" "bastion" "aks" "roles")

echo "----- Terraform init -----"

for folder in "${FOLDERS[@]}"
do
  echo "---------------------------"
  echo "Terraform init $folder"
  echo "---------------------------"
  cd ./$folder
  sudo rm -r .terraform
  terraform init
  cd ..
  echo " "
done