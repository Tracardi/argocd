# Elastic

kubectl delete -f https://download.elastic.co/downloads/eck/2.1.0/crds.yaml
kubectl delete -f https://download.elastic.co/downloads/eck/2.1.0/operator.yaml

# Percona

helm delete percona-op --namespace percona
helm delete percona-db --namespace percona