kubectl create ns pulsar

CURRENT_DIRECTORY=$(pwd)

cd /tmp

git clone --branch pulsar-3.2.0 https://github.com/apache/pulsar-helm-chart
cd pulsar-helm-chart
./scripts/cert-manager/install-cert-manager.sh
./scripts/pulsar/prepare_helm_release.sh -k pulsar -n pulsar

cd $CURRENT_DIRECTORY

helm upgrade --install pulsar apache/pulsar  -n pulsar