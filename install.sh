# Namespaces

kubectl create namespace argocd
kubectl create namespace starrocks
kubectl create namespace pulsar
kubectl create namespace elastic
kubectl create namespace percona
kubectl create namespace redis

# Install all required operators, etc.

## Argo
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

### Setup argo
kubectl apply -f setup/argocd-setup.yaml

## Redis

helm repo add bitnami https://charts.bitnami.com/bitnami

## Pulsar

helm repo add apache https://pulsar.apache.org/charts

## Starrocks

helm repo add starrocks-community https://starrocks.github.io/starrocks-kubernetes-operator


## Elastic

# Operators in helm

kubectl apply -f https://download.elastic.co/downloads/eck/2.1.0/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/2.1.0/operator.yaml


## Percona

helm repo add percona https://percona.github.io/percona-helm-charts/


# Installation

## Cert manager

cd /tmp
git clone https://github.com/apache/pulsar-helm-chart
cd pulsar-helm-chart
./scripts/cert-manager/install-cert-manager.sh


## Prepare pulsar helm release

git clone https://github.com/apache/pulsar-helm-chart
cd pulsar-helm-chart
./scripts/pulsar/prepare_helm_release.sh -n pulsar -k pulsar
