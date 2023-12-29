kubectl create namespace percona-2
helm install percona-op percona/pxc-operator --namespace percona-2
helm install percona-db percona/pxc-db --values percona/local-values.yaml --namespace percona-2