#!/bin/bash

#resize disk from 20GB to 50GB
lsblk
df -hT
name=$(lsblk -dn -o NAME | head -n 1)
growpart /dev/$name 4
# growpart /dev/nvme0n1 4
df -hT

# resize logical volumes
lvextend -L +10G /dev/mapper/RootVG-homeVol
lvextend -L +10G /dev/mapper/RootVG-varVol
lvextend -l +100%FREE /dev/mapper/RootVG-varTmpVol

# resize filesystems
xfs_growfs /home
xfs_growfs /var/tmp
xfs_growfs /var

#java
yum install java-17-openjdk -y

#terraform
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install terraform

dnf module disable nodejs -y
dnf module enable nodejs:20 -y
dnf install nodejs -y
yum install zip -y

# docker
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# Maven for Java projects
dnf install maven -y

# Python for python projects
dnf install python3.11 gcc python3-devel -y

# # Install ArgoCD CLI
# curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
# chmod +x /usr/local/bin/argocd

# # Deploy ArgoCD in Kubernetes (if a cluster is available)
# kubectl create namespace argocd
# kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# # Expose ArgoCD Server (Optional - using LoadBalancer or NodePort)
# kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# # Retrieve Initial Admin Password
# echo "ArgoCD Admin Password:"
# kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d && echo