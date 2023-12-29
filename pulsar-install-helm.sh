kubectl create ns pulsar

CURRENT_DIRECTORY=$(pwd)

cd /tmp

git clone https://github.com/apache/pulsar-helm-chart
cd pulsar-helm-chart
./scripts/cert-manager/install-cert-manager.sh

git clone https://github.com/apache/pulsar-helm-chart
cd pulsar-helm-chart
./scripts/pulsar/prepare_helm_release.sh -k pulsar -n pulsar

cd $CURRENT_DIRECTORY

helm upgrade --install pulsar apache/pulsar --values pulsar/local-values.yaml -n pulsar