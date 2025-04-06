#!/usr/bin/env bash

curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o kubectl
chmod +x kubectl
mv ./kubectl /usr/local/bin/kubectl
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64
k3d cluster create mycluster
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
echo "Installation finished!"
echo "Wait until the pods are running..."
kubectl wait... 
argocd admin initial-password -n argocd
echo "Port forwarding active. Stop with ^C"
echo "restart with:"
echo "kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8080:443"
kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8080:443