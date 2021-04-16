#!/bin/bash

FOLDERS=("aks" "roles")

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