helm repo add apache https://pulsar.apache.org/charts
helm repo add percona https://percona.github.io/percona-helm-charts/
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

kubectl apply -f https://download.elastic.co/downloads/eck/2.10.0/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/2.10.0/operator.yaml

# Redis
kubectl create namespace redis
helm upgrade --install redis bitnami/redis --values redis/min-values.yaml --namespace redis --create-namespace


# Install percona
NS="percona"

kubectl create namespace $NS
helm upgrade --install percona-op percona/pxc-operator --namespace $NS
helm upgrade --install percona-db percona/pxc-db --values percona/min-values.yaml --namespace $NS

# Pulsar

kubectl create ns pulsar
CURRENT_DIRECTORY=$(pwd)
cd /tmp

rm -rf pulsar-helm-chart
git clone --branch pulsar-3.2.0 https://github.com/apache/pulsar-helm-chart
cd pulsar-helm-chart
./scripts/cert-manager/install-cert-manager.sh
./scripts/pulsar/prepare_helm_release.sh -k pulsar -n pulsar

cd $CURRENT_DIRECTORY

helm upgrade --install pulsar apache/pulsar --values pulsar/min-values.yaml -n pulsar

# Elastic
kubectl create ns elastic
helm upgrade --install elastic elastic --values elastic/min-values.yaml -n elastic

