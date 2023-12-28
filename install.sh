# Namespaces

kubectl create namespace starrocks
kubectl create namespace pulsar
kubectl create namespace elastic
kubectl create namespace percona
kubectl create namespace redis

# Install all required operators, etc.

## Argo


## Pulsar

helm repo add apache https://pulsar.apache.org/charts

## Starrocks

helm repo add starrocks-community https://starrocks.github.io/starrocks-kubernetes-operator


## Elastic

kubectl apply -f https://download.elastic.co/downloads/eck/2.1.0/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/2.1.0/operator.yaml


## Percona

helm repo add percona https://percona.github.io/percona-helm-charts/
