#!/bin/bash
#before running this script the sensitive env variables need to be exported
#please check the envs-production or the envs-$ENVIRONMENT files for more information
echo "updating credentials for the run"
az aks get-credentials -g $ENVIRONMENT-$COMPANY_NAME -n $ENVIRONMENT --overwrite-existing

echo "Setting up basic namespaces and Drone service-account"
kubectl apply -f ./kubectl/setup.yaml
echo "namespaces and service-account created successfully"

./cert_creation.sh $COMPANY_DOMAIN

echo "----------------------------------------------------------"
echo "Creating Container-Registry Credentials secret"

registrySecret=$(kubectl get secret -n drone |grep drone-regcred |cut -c1-5)
if [ "$registrySecret" == "drone" ]; then
    echo "$ENVIRONMENT-regcred secret already exists, destruction in progress"
    kubectl delete secret drone-regcred -n drone
    kubectl delete secret staging-regcred -n drone
    kubectl delete secret dev-regcred -n dev
    kubectl delete secret stg-regcred -n stg
    kubectl delete secret sre-regcred -n sre
    kubectl delete secret prd-regcred -n prd
    kubectl delete secret default-tls -n sre
    kubectl delete secret k8s-stg -n drone

fi

echo "Creating the $ENVIRONMENT-regcred secret"
kubectl create secret docker-registry drone-regcred -n drone --docker-server=$DOCKER_REGISTRY_ADDRESS --docker-username=$DOCKER_REGISTRY_USER --docker-password=$DOCKER_REGISTRY_PWD --docker-email=$DOCKER_REGISTRY_EMAIL
kubectl create secret docker-registry staging-regcred -n dev --docker-server=$DOCKER_REGISTRY_ADDRESS --docker-username=$DOCKER_REGISTRY_USER --docker-password=$DOCKER_REGISTRY_PWD --docker-email=$DOCKER_REGISTRY_EMAIL
kubectl create secret docker-registry stg-regcred -n stg --docker-server=$DOCKER_REGISTRY_ADDRESS --docker-username=$DOCKER_REGISTRY_USER --docker-password=$DOCKER_REGISTRY_PWD --docker-email=$DOCKER_REGISTRY_EMAIL
kubectl create secret docker-registry sre-regcred -n sre --docker-server=$DOCKER_REGISTRY_ADDRESS --docker-username=$DOCKER_REGISTRY_USER --docker-password=$DOCKER_REGISTRY_PWD --docker-email=$DOCKER_REGISTRY_EMAIL
kubectl create secret docker-registry prd-regcred -n prd --docker-server=$DOCKER_REGISTRY_ADDRESS --docker-username=$DOCKER_REGISTRY_USER --docker-password=$DOCKER_REGISTRY_PWD --docker-email=$DOCKER_REGISTRY_EMAIL
kubectl create secret tls default-tls -n sre --key ${COMPANY_DOMAIN}.key --cert ${COMPANY_DOMAIN}.crt

cat ~/.kube/config | base64 -w0 > ./k8s-stg
kubectl create secret generic -n drone k8s-stg --from-file=./k8s-stg

echo "$ENVIRONMENT-regcred secret created successfully"
echo "----------------------------------------------------------"
echo "Helm install of first dependencies:  AGIC, DRONE, Cert_Manager and ExternalDNS"
echo "----------------------------------------------------------"
echo "Parsing the sensitive env variables to the AGIC values files"

sed -i 's|"<subscriptionId>"|'$ARM_SUBSCRIPTION_ID'|g' ./helm/helmfiles/ingress-azure-controller/values.yaml
sed -i 's|"<secretjson>"|'$SECRET_JSON'|g' ./helm/helmfiles/ingress-azure-controller/values.yaml

echo "----------------------------------------------------------"
echo "Parsing the env variables to the external-DNS values files"

sed -i 's|"<tenantdId>"|'$ARM_TENANT_ID'|g' ./helm/helmfiles/external-dns/values.yaml
sed -i 's|"<subscriptionId>"|'$ARM_SUBSCRIPTION_ID'|g' ./helm/helmfiles/external-dns/values.yaml
sed -i 's|"<aadClientId>"|'$ARM_CLIENT_ID'|g' ./helm/helmfiles/external-dns/values.yaml
sed -i 's|"<aadClientSecret>"|'$ARM_CLIENT_SECRET'|g' ./helm/helmfiles/external-dns/values.yaml

sed -i 's|"<tenantdId>"|'$ARM_TENANT_ID'|g' ./helm/helmfiles/external-dns/private.yaml
sed -i 's|"<subscriptionId>"|'$ARM_SUBSCRIPTION_ID'|g' ./helm/helmfiles/external-dns/private.yaml
sed -i 's|"<aadClientId>"|'$ARM_CLIENT_ID'|g' ./helm/helmfiles/external-dns/private.yaml
sed -i 's|"<aadClientSecret>"|'$ARM_CLIENT_SECRET'|g' ./helm/helmfiles/external-dns/private.yaml

echo "----------------------------------------------------------"
echo "Parsing the env variables to the Drone values files"

sed -i 's|"<DRONE_SERVER_PROTO>"|'$DRONE_SERVER_PROTO'|g' ./helm/helmfiles/drone/server-values.yaml
sed -i 's|"<DRONE_RPC_SECRET>"|'$DRONE_RPC_SECRET'|g' ./helm/helmfiles/drone/server-values.yaml
sed -i 's|"<DRONE_USER_CREATE>"|'$DRONE_USER_CREATE'|g' ./helm/helmfiles/drone/server-values.yaml
sed -i 's|"<DRONE_GITLAB_CLIENT_ID>"|'$DRONE_GITLAB_CLIENT_ID'|g' ./helm/helmfiles/drone/server-values.yaml
sed -i 's|"<DRONE_GITLAB_CLIENT_SECRET>"|'$DRONE_GITLAB_CLIENT_SECRET'|g' ./helm/helmfiles/drone/server-values.yaml
sed -i 's|"<DRONE_GITEA_CLIENT_ID>"|'$DRONE_GITEA_CLIENT_ID'|g' ./helm/helmfiles/drone/server-values.yaml
sed -i 's|"<DRONE_GITEA_CLIENT_SECRET>"|'$DRONE_GITEA_CLIENT_SECRET'|g' ./helm/helmfiles/drone/server-values.yaml
sed -i 's|"<DRONE_GITEA_SERVER>"|'$DRONE_GITEA_SERVER'|g' ./helm/helmfiles/drone/server-values.yaml

sed -i 's|"<DRONE_RPC_SECRET>"|'$DRONE_RPC_SECRET'|g' ./helm/helmfiles/drone/runner-values.yaml
sed -i 's|"<DRONE_RPC_SECRET>"|'$DRONE_RPC_SECRET'|g' ./helm/helmfiles/drone/secrets-values.yaml

echo "----------------------------------------------------------"
echo "Applying helmfile.yaml"
helmfile --file helm/helmfile.yaml apply

echo "----------------------------------------------------------"
echo "Parsing the env variables to the drone_secrets_values file"

sed -i 's|"<docker_username>"|'$DOCKER_REGISTRY_USER'|g' ./kubectl/drone-secrets.yaml
sed -i 's|"<docker_password>"|'$DOCKER_REGISTRY_PWD'|g' ./kubectl/drone-secrets.yaml
sed -i 's|"<docker_registry>"|'$DOCKER_REGISTRY_ADDRESS'|g' ./kubectl/drone-secrets.yaml
sed -i 's|"<rabbitmq_pwd>"|'$RABBITMQ_PWD'|g' ./kubectl/drone-secrets.yaml
sed -i 's|"<rabbitmq_ErCookie>"|'$RABBITMQ_ERCOOKIE'|g' ./kubectl/drone-secrets.yaml
sed -i 's|"<rabbitmq_pwdHash>"|'$RABBITMQ_PWD_HASH'|g' ./kubectl/drone-secrets.yaml

echo "----------------------------------------------------------"
echo "Waiting for cert_manager_pods"

echo "sleeping a little bit while cert_manager_pods start"
sleep 2m

kubectl apply -f ./kubectl/drone-secrets.yaml
kubectl apply -f ./kubectl/lets-encript.yaml

echo "Creation of drone-secrets completed successfully"

echo "----------------------------------------------------------"
echo "Cleaning sensitive data from repo"

cp ./kubectl/drone-secrets-bak.yaml ./kubectl/drone-secrets.yaml
cp ./kubectl/lets-encript-issuer-bak.yaml ./kubectl/lets-encript-issuer.yaml
cp ./helm/helmfiles/drone/secrets-values-bak.yaml ./helm/helmfiles/drone/secrets-values.yaml
cp ./helm/helmfiles/drone/runner-values-bak.yaml ./helm/helmfiles/drone/runner-values.yaml
cp ./helm/helmfiles/drone/server-values-bak.yaml ./helm/helmfiles/drone/server-values.yaml
cp ./helm/helmfiles/external-dns/values-bak.yaml ./helm/helmfiles/external-dns/values.yaml
cp ./helm/helmfiles/external-dns/private-bak.yaml ./helm/helmfiles/external-dns/private.yaml
cp ./helm/helmfiles/ingress-azure-controller/values-bak.yaml ./helm/helmfiles/ingress-azure-controller/values.yaml
rm ./${COMPANY_DOMAIN}.crt
rm ./${COMPANY_DOMAIN}.key
rm ./k8s-stg