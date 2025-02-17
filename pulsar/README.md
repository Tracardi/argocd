# Manual install

## Operators

```
helm repo add apache https://pulsar.apache.org/charts
helm repo update
```

# Namespace

```
kubectl create ns pulsar
```

## Cert manager

```
git clone https://github.com/apache/pulsar-helm-chart
cd pulsar-helm-chart
./scripts/cert-manager/install-cert-manager.sh
```

## Prepare helm release

```
git clone https://github.com/apache/pulsar-helm-chart
cd pulsar-helm-chart
./scripts/pulsar/prepare_helm_release.sh -n pulsar -k pulsar
```

The prepare_helm_release creates the following resources:

- A Kubernetes namespace for installing the Pulsar release.
- JWT secret keys and tokens for three super users: broker-admin, proxy-admin, and admin. By default, it generates an asymmetric public/private key pair. You can choose to generate a symmetric secret key by specifying --symmetric.
    * the broker-admin role is used for inter-broker communications.
    * the proxy-admin role is used for proxies to communicate with brokers.
    * the admin role is used by the admin tools.

```
helm upgrade --install pulsar apache/pulsar --values local-values.yaml -n pulsar
```


# Trouble shooting

If you face:

```
Release "pulsar" does not exist. Installing it now.
Error: unable to build kubernetes objects from release manifest: [resource mapping not found for name: "pulsar-recovery" namespace: "" from "": no matches for kind "PodMonitor" in version "monitoring.coreos.com/v1"
ensure CRDs are installed first, resource mapping not found for name: "pulsar-broker" namespace: "" from "": no matches for kind "PodMonitor" in version "monitoring.coreos.com/v1"
ensure CRDs are installed first, resource mapping not found for name: "pulsar-proxy" namespace: "" from "": no matches for kind "PodMonitor" in version "monitoring.coreos.com/v1"
ensure CRDs are installed first]
```

Enable monitoring

kube-prometheus-stack:
  enabled: true  <- set to true