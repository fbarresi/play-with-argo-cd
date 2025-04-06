#!/usr/bin/env bash

echo "installing kubectl..."
curl -sL -o kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv ./kubectl /usr/local/bin/kubectl

echo "installing k3d..."
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo "installing argocd cli..."
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

echo "creating cluster..."
k3d cluster create mycluster

echo "deploy argo cd..."
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

echo "installation finished!"
echo "wait until the pods are running..."
kubectl wait pod --all --for=condition=Ready --namespace=argocd
sleep 5s

argocd admin initial-password -n argocd

echo "port forwarding active. Stop with ^C"
echo "restart forwarding with:"
echo "kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8080:443"
kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8080:443
