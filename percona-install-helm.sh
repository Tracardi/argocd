NS="percona"

kubectl create namespace $NS
helm upgrade --install percona-op percona/pxc-operator --namespace $NS
helm upgrade --install percona-db percona/pxc-db --values percona/local-values.yaml --namespace $NS