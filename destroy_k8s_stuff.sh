#!/bin/bash


kubectl delete -f ./kubectl/drone-secrets.yaml
kubectl delete -f ./kubectl/lets-encript.yaml

helmfile --file helm/helmfile.yaml delete

kubectl delete secret $ENVIROMENT-regcred -n drone
kubectl delete secret $ENVIROMENT-regcred -n dev
kubectl delete secret $ENVIROMENT-regcred -n stg
kubectl delete secret $ENVIROMENT-regcred -n sre
kubectl delete secret production-regcred -n prd


kubectl delete -f ./kubectl/setup.yaml