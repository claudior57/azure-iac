#!/bin/bash

FOLDERS=("rg" "acr" "nsg" "vnet" "log" "gateway" "bastion" "aks" "roles")

echo "----- Terraform Plan -----"

for folder in "${FOLDERS[@]}"
do
  full_db_name="$envi-$db_name"
  echo "---------------------------"
  echo "Terraform planning module $folder"
  echo "---------------------------"
  cd ./$folder
  terraform plan
  cd ..
  echo " "
done

