helm repo add percona https://percona.github.io/percona-helm-charts/
helm repo update
kubectl create namespace percona
helm install percona-op percona/pxc-operator --namespace percona
helm install percona-db percona/pxc-db --namespace percona
