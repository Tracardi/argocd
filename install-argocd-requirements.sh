# Namespaces

kubectl create namespace argocd
#kubectl create namespace starrocks
#kubectl create namespace pulsar
#kubectl create namespace elastic
kubectl create namespace percona-2
#kubectl create namespace redis
kubectl create namespace cert-manager
kubectl create namespace operators

# Install ArgoCD

## Argo
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

### Setup argo
kubectl apply -f setup/argocd-setup.yaml
kubectl apply -f setup/argocd-rbac.yaml
#kubectl apply -f setup/argocd-repos.yaml
kubectl apply -f setup/argocd-projects.yaml

# Install Repos

## Redis

helm repo add bitnami https://charts.bitnami.com/bitnami

## Pulsar

helm repo add streamnative https://charts.streamnative.io
helm repo add apache https://pulsar.apache.org/charts

### Prometheus

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

## Starrocks

helm repo add starrocks-community https://starrocks.github.io/starrocks-kubernetes-operator


## Percona

helm repo add percona https://percona.github.io/percona-helm-charts/


# Install operators

## Elastic

kubectl apply -f https://download.elastic.co/downloads/eck/2.1.0/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/2.1.0/operator.yaml

## Percona

helm install percona-op percona/pxc-operator --namespace percona-2


# Install prerequisites

## Prometheus

helm install prometheus prometheus-community/kube-prometheus-stack

## Cert manager

cd /tmp
git clone https://github.com/apache/pulsar-helm-chart
cd pulsar-helm-chart
./scripts/cert-manager/install-cert-manager.sh


## Prepare pulsar helm release

kubectl create namespace pulsar
git clone https://github.com/apache/pulsar-helm-chart
cd pulsar-helm-chart
./scripts/pulsar/prepare_helm_release.sh -n pulsar -k pulsar


