#!/bin/bash

export ENVIROMENT=staging

#populating the envs from staging file and making them available on the main shell
. ./envs-staging.sh

##Running terraform_apply script
cd terraform
. ./terraform_apply_demo.sh
cd ..

#running helm_install
. ./helm_install.sh