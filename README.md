# Installation

Tracardi can be installed using installation scripts.

## Prerequisites


* kubectl 1.21 or higher, compatible with your cluster (+/- 1 minor release from your cluster)
* Helm v3 (3.10.0 or higher)
* A Kubernetes cluster, version 1.21 or higher.


## Install Dependencies Using Helm Scripts

Tracardi depends on:

- Elasticsearch
- Apache Pulsar
- Redis
- Mysql (Percona)

### Install Elasticsearch

```
cd argocd
bash ./elastic-install-operator.sh
bash ./elastic-install-helm.sh
```

To customize installation values go to: elastic/local-values.yaml

### Install Apache Pulsar

```
cd argocd
bash ./pulsar-install-helm.sh
```

To customize installation values go to: pulsar/local-values.yaml

### Install Redis

```
cd argocd
bash ./redis-install-repo.sh
bash ./redis-install-helm.sh
```

To customize installation values go to: redis/local-values.yaml


### Install Redis

```
cd argocd
bash ./percona-install-repo.sh
bash ./percona-install-helm.sh
```

To customize installation values go to: percona/local-values.yaml


## Install Tracardi Using Helm Scripts

Current version is 0.9.0

### Configuration

Before you start copy docker-hub access token to DOCKERHUB in file ./090-tracardi-install-helm.sh:

```
DOCKERHUB="docker-hub access token"
```


#### Configure access to dependent resources.

Go to file: `tracardi/090-local-com-values.yaml`

This part is responsible for connecting to dependencies. With this setup most values should be correct. No need to change anything.

```yaml
elastic:
  name: es1
  host: cluster-es-http.elastic.svc.cluster.local
  schema: https
  authenticate: true
  port: 9200
  verifyCerts: "no"

redis:
  name: rd1
  host: redis-master.redis.svc.cluster.local
  schema: "redis://"
  authenticate: true
  port: 6379
  db: "0"

pulsar:
  name: ps1
  host: pulsar-proxy.pulsar.svc.cluster.local:6650
  api: http://pulsar-broker.pulsar.svc.cluster.local:8080
  schema: "pulsar://"
  authenticate: true
  port: 6650

mysql:
  name: ms1
  host: percona-db-pxc-db-haproxy.percona.svc.cluster.local
  username: root
  password: root
  schema: "mysql+aiomysql://"
  database: "tracardi"
  port: 3306
```

This part has all the secrets. Please copy the secrets for the dependant resources.

```yaml
secrets:
  installationToken: "RISTO"
  dockerHub: "tracardi-dockerhub"
  license:
    licenseKey: "<copy-license-here>"
  redis:
    password: "<copy-redis-password>"
  elastic:
    password: "<copy-elastic-password>"
  pulsar:
    token: "<copy-pulsar-token>"
  mysql:
    username: "root"
    password: "<copy-mysql-password>"
```

If you store credentials in secrets then there is a `valueFrom` option for every secret.

This is the example use for redis:

Instead of setting credentials this way, as in the example above:

```yaml
  redis:
    password: ""
```

Set it this way:

```yaml
  redis:
    valueFrom:
      password:
        name: ""
        key: ""
```

The same way can be set any of the dependant resource:

Example can be found in: tracardi/values.yaml

### Installation

When all the credentials and URLs are set, run:

```
bash ./090-tracardi-install-helm.sh
```

it will use tracardi/090-local-com-values.yaml for custom settings. It will basically do this:

```
NS="tracardi-com-090"
VALUES="090-local-com-values.yaml"
DOCKERHUB=""

kubectl create ns $NS

kubectl create secret docker-registry tracardi-dockerhub \
    --docker-server=index.docker.io/v1/  \
    --docker-username=tracardi \
    --docker-password=$DOCKERHUB \
    -n $NS

helm upgrade --install tracardi tracardi -f tracardi/$VALUES -n $NS
```

## UnInstall Tracardi

```
kubectl delete ns tracardi-com-090
```

## UnInstall Dependencies Using Helm Scripts

### Elasticsearch

```
cd argocd
bash ./elastic-uninstall-helm.sh
bash ./elastic-uninstall-operator.sh
```

### Apache Pulsar

```
cd argocd
bash ./pulsar-uninstall-helm.sh
```

### Redis

```
cd argocd
bash ./redis-uninstall-helm.sh
```

### Mysql (Percona)

```
cd argocd
bash ./percona-uninstall-helm.sh
```