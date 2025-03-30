NS="percona"

kubectl create namespace $NS
helm install percona-op percona/pxc-operator --namespace $NS
helm install percona-db percona/pxc-db --values local-values.yaml --namespace $NS