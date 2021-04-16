#!/bin/sh

echo "Modifying the Sudoers file"

sudo rm /etc/sudoers.d/aad_admins
echo '%aad_admins ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/aad_admins

echo "Installing AZ CLI"
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

echo "Installing Tools"
mkdir downloads
cd ./downloads

echo "Installing Kubectl"
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
sudo mv ./kubectl /usr/bin/

echo "Installing Helm3"
wget -O helm.tar.gz https://get.helm.sh/helm-v3.2.4-linux-amd64.tar.gz
tar -vzxf helm.tar.gz
cd linux-amd64
sudo chmod +x helm
sudo mv ./helm /usr/bin/
echo "installing Helm-Diff plugin"
helm plugin install https://github.com/databus23/helm-diff
cd ..

echo "Installing K9s"
wget -O k9s.tar.gz https://github.com/derailed/k9s/releases/download/v0.21.7/k9s_Linux_x86_64.tar.gz
tar -vzxf k9s.tar.gz
sudo chmod +x k9s
sudo mv ./k9s /usr/bin/

echo "Installing Helmfile"
wget -O helmfile https://github.com/roboll/helmfile/releases/download/v0.125.2/helmfile_linux_amd64
sudo chmod +x helmfile
sudo mv ./helmfile /usr/bin/

echo "cleaning stuff"
cd ..
sudo rm -r downloads
