# Installation

## Install ArgoCD

```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

## Install

Installing as Kubernetes workload in Argo CD namespace

```
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml
```

## Install OLM (Operator Lifecycle Manager) - https://github.com/operator-framework/operator-lifecycle-manager

### Install operator-sdk

Installs operator-sdk on you system

```
export ARCH=$(case $(uname -m) in x86_64) echo -n amd64 ;; aarch64) echo -n arm64 ;; *) echo -n $(uname -m) ;; esac)
export OS=$(uname | awk '{print tolower($0)}')
export OPERATOR_SDK_DL_URL=https://github.com/operator-framework/operator-sdk/releases/download/v1.32.0
curl -LO ${OPERATOR_SDK_DL_URL}/operator-sdk_${OS}_${ARCH}
chmod +x operator-sdk_${OS}_${ARCH} && sudo mv operator-sdk_${OS}_${ARCH} /usr/local/bin/operator-sdk
```

Use below command to install the OLM

```
operator-sdk olm install
```

!!! Warning

    I had issues installing it on k3s when local-path was not the default storageClass.


## Override default subscription check

```
kubectl apply -f setup/argocd-setup.yaml
```

This will make ArgoCD wait for the operators to install before proceeding.

# DELETE OLM

```
operator-sdk olm uninstall
```