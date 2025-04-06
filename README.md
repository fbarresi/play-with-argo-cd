# Play with Argo CD
a repository guide for creating a k8s cluster with argo cd on demand

The scripts in this repo were tested with [play-with-docker](https://labs.play-with-docker.com/) : a wonderful plaform to play directly in the browser. (registration needed)

Of course you can use them even locally. <br/>
If you want to learn more about Argo CD, please visit the [project page](https://argoproj.github.io/cd/) or [GitOps](https://www.gitops.tech/)

## Before you start
- open [play-with-docker](https://labs.play-with-docker.com/) and create a node
- (alternative) make sure you can use a bash on your linux target machine as root

## Quick Start
use the script:
```
curl -s https://raw.githubusercontent.com/fbarresi/play-with-argo-cd/main/install.sh | bash
```

## Step by step guide

### Install kubectl 
[official guide](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv ./kubectl /usr/local/bin/kubectl
```

### Install k3d 
[official guide](https://k3d.io/stable/)
```
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
```

### Install argocd CLI
[official guide](https://argo-cd.readthedocs.io/en/stable/cli_installation/)
```
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64
```

### Create a new cluster
```
k3d cluster create mycluster
```

### Deploy Argo CD
[official guide](https://argo-cd.readthedocs.io/en/stable/getting_started/) 
```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### Patch Argo CD API Server
```
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

### Retrieve initial password
```
argocd admin initial-password -n argocd
```

### Expose web UI
```
kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8080:443
```

### Done!
Now you can start open the web UI the port 8080 and play with your minimal kubernetes instance with Argo CD.

In Play-with-docker it works this way:
![image](https://github.com/user-attachments/assets/43c33057-dfa1-48ce-a697-3582e6c36375)


## Did you like it?
I hope so, don't forget to ⭐ this project!

Feel free to contribute via PR.

#### Further links
You might also like [play-with-k8s](https://labs.play-with-k8s.com/) : another similar playground for kubernetes (but sadly with no port forwarding).

