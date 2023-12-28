# Manual install

## Operators

```
helm repo add streamnative https://charts.streamnative.io
helm repo update
helm install pulsar-operator streamnative/pulsar-operator -n pulsar
helm install pulsar-resources-operator streamnative/pulsar-resources-operator -n pulsar
```


## Cert manager

```
git clone https://github.com/apache/pulsar-helm-chart
cd pulsar-helm-chart
./scripts/cert-manager/install-cert-manager.sh
```

## Authentication

```
git clone https://github.com/streamnative/charts.git
cd charts
./scripts/pulsar/prepare_helm_release.sh -n pulsar -k pulsar
```

The prepare_helm_release creates the following resources:
- A Kubernetes namespace for installing the Pulsar release.
- JWT secret keys and tokens for three super users: broker-admin, proxy-admin, and admin. By default, it generates an asymmetric public/private key pair. You can choose to generate a symmetric secret key by specifying --symmetric.
    * the broker-admin role is used for inter-broker communications.
    * the proxy-admin role is used for proxies to communicate with brokers.
    * the admin role is used by the admin tools.

# Install

```
kubectl apply -f zk-cluster.yaml -n pulsar
kubectl apply -f bk-cluster.yaml -n pulsar
kubectl apply -f br-cluster.yaml -n pulsar
kubectl apply -f px-cluster.yaml -n pulsar
```