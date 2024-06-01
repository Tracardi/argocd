## Using Custom Values in HelmCharts for Tracardi Installation

### Introduction

When installing Tracardi using HelmCharts, you can customize the deployment by providing your own `values.yaml` file.
This file overrides the default values defined in the HelmChart, allowing you to tailor the installation to meet your
specific needs.

### Custom Values File

Your custom `values.yaml` file will contain only the values you wish to change from the defaults. Any values not
specified in your custom file will use the defaults provided by the HelmChart. This approach keeps your configuration
concise and easy to manage.

### Advice on Setting Up Dependencies

We strongly recommend setting up the dependent services (Redis, Elasticsearch, MySQL, and Pulsar) in separate
namespaces. This strategy has several advantages:

1. **Upgrade Management**: Each new version of Tracardi can be deployed in a new namespace, facilitating migration and
   testing without disrupting the current setup.
2. **Isolation**: Keeping dependencies isolated helps in managing and troubleshooting issues more effectively.
3. **Avoiding In-Place Upgrades**: Placing everything in one namespace would necessitate an in-place upgrade for
   Tracardi, which is not recommended due to the increased risk of disruptions and complications.

### Namespace Setup Example

Here is an example of how you might set up namespaces for each service:

## Dependencies Installation

Tracardi dependencies can be installed using installation scripts. Provided script may need changes for proper scalling.

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

### Install Percona

```
cd argocd
bash ./percona-install-repo.sh
bash ./percona-install-helm.sh
```

To customize installation values go to: percona/local-values.yaml

## Infrastructure Configuration for Various Services Used by Tracardi

Infrastructure installation is the part in helm configuration that defines all the services that Tracardi needs to connect to. 

### Elasticsearch Configuration

The Elasticsearch configuration specifies the necessary settings to connect Tracardi to an Elasticsearch service. This
includes the host, port, schema, and authentication details. Here's a detailed breakdown:

```yaml
elastic:
  name: es1  # The name identifier for the Elasticsearch service
  host: elastic-std-svc.elastic-standalone.svc.cluster.local  # The hostname for the Elasticsearch service
  schema: http  # The schema to use for connecting to Elasticsearch (http/https)
  authenticate: false  # Whether to use authentication when connecting to Elasticsearch
  port: 9200  # The port on which Elasticsearch is running
  verifyCerts: "no"  # Whether to verify SSL certificates (yes/no)
  index:
    shards: 3  # Number of primary shards for the index
    replicas: 1  # Number of replica shards for the index
```

| Field              | Description                                                              | Needs change          |
|--------------------|--------------------------------------------------------------------------|-----------------------|
| **name**           | Identifier for the Elasticsearch service                                 |                       |
| **host**           | Hostname or IP address of the Elasticsearch service                      | yes                   |
| **schema**         | Protocol used to connect (http or https)                                 | yes                   |
| **authenticate**   | Toggle for enabling authentication. See secrets part for authentication. | yes                   |
| **port**           | Port number on which Elasticsearch is running                            |                       |
| **verifyCerts**    | Indicates whether SSL certificates should be verified                    |                       |
| **index.shards**   | Number of primary shards for the index                                   | Use default or change |
| **index.replicas** | Number of replica shards for the index                                   | Use default or change                      |

### Redis Configuration

The Redis configuration sets up the connection details for the Redis service, including the host, port, and database
number.

```yaml
redis:
  name: rd1  # The name identifier for the Redis service
  host: redis-std-svc.redis-standalone.svc.cluster.local  # The hostname for the Redis service
  schema: "redis://"  # The schema to use for connecting to Redis
  authenticate: false  # Whether to use authentication when connecting to Redis
  port: 6379  # The port on which Redis is running
  db: "0"  # The database number to use in Redis
```

| Field             | Description                                      |Needs change|
|-------------------|--------------------------------------------------|-|
| **name**          | Identifier for the Redis service                 ||
| **host**          | Hostname or IP address of the Redis service      |yes|
| **schema**        | Protocol used to connect (e.g., redis://)        ||
| **authenticate**  | Toggle for enabling authentication               |yes|
| **port**          | Port number on which Redis is running            ||
| **db**            | Redis database number to use                     ||

### Apache Pulsar Configuration

The Apache Pulsar configuration includes settings for connecting to the Pulsar service, including the host, port, and
whether to enable Pulsar.

```yaml
pulsar:
  name: ps1  # The name identifier for the Pulsar service
  host: pulsar-std-svc.pulsar-standalone.svc.cluster.local  # The hostname for the Pulsar service
  api: "http://pulsar-std-svc.pulsar-standalone.svc.cluster.local:8080"  # API endpoint for Pulsar
  schema: "pulsar://"  # The schema to use for connecting to Pulsar
  authenticate: false  # Whether to use authentication when connecting to Pulsar
  port: 6650  # The port on which Pulsar is running
  cluster_name: pulsar  # The cluster name for Pulsar
  enabled: true  # Whether Pulsar is enabled
```

| Field             | Description                                      | needs change |
|-------------------|--------------------------------------------------|--------------|
| **name**          | Identifier for the Pulsar service                |              |
| **host**          | Hostname or IP address of the Pulsar service     | yes          |
| **api**           | API endpoint for Pulsar                          | yes          |
| **schema**        | Protocol used to connect (e.g., pulsar://)       |              |
| **authenticate**  | Toggle for enabling authentication               | yes          |
| **port**          | Port number on which Pulsar is running           |              |
| **cluster_name**  | Name of the Pulsar cluster                       |              |
| **enabled**       | Toggle to enable or disable Pulsar               |              |

### MySQL Configuration

The MySQL configuration details the settings for connecting to a MySQL service, including the host, port, and database
name.

```yaml
mysql:
  name: ms1  # The name identifier for the MySQL service
  host: percona-db-pxc-db-haproxy.percona.svc.cluster.local  # The hostname for the MySQL service
  schema: "mysql+aiomysql://"  # The schema to use for connecting to MySQL
  database: "tracardi"  # The database name to use in MySQL
  port: 3306  # The port on which MySQL is running
```

| Field             | Description                                      | Needs change |
|-------------------|--------------------------------------------------|--------------|
| **name**          | Identifier for the MySQL service                 |              |
| **host**          | Hostname or IP address of the MySQL service      | yes          |
| **schema**        | Protocol used to connect (e.g., mysql+aiomysql://)|              |
| **database**      | Name of the database to use                      |              |
| **port**          | Port number on which MySQL is running            |              |

### Tenant Management Service (TMS) API Configuration

The TMS API configuration outlines the settings for the Tenant Management Service, a microservice responsible for
managing tenants in a multi-tenant environment.

```yaml
tmsApi:
  host: be-fa-tms-svc.tracardi-com-090.svc.cluster.local  # The hostname for the TMS API service
  database: "tms"  # The database name to use in TMS API
```

| Field             | Description                                      | Needs change |
|-------------------|--------------------------------------------------|--------------|
| **host**          | Hostname or IP address of the TMS API service    | yes          |
| **database**      | Name of the database to use in TMS API           |              |

Here's an example `values.yaml` file where only the required fields are changed. This is the example for resource
configuration. See other parts below

```yaml
# Elasticsearch configuration. Set required values like elastic.host
elastic:
  host: elastic-std-svc.elastic-standalone.svc.cluster.local
  authenticate: true

# Redis configuration. 
redis:
  host: redis-std-svc.redis-standalone.svc.cluster.local
  authenticate: true

# Apache Pulsar configuration. Set required fields like pulsar.host, pulsar.api
pulsar:
  host: pulsar-std-svc.pulsar-standalone.svc.cluster.local
  api: "http://pulsar-std-svc.pulsar-standalone.svc.cluster.local:8080"
  enabled: true  # Enable Pulsar for this configuration
  authenticate: true

# MySQL configuration. Set mysql.host required.
mysql:
  host: percona-db-pxc-db-haproxy.percona.svc.cluster.local

# TMS API configuration. Change tmsApi.host
tmsApi:
  host: be-fa-tms-svc.tracardi-com-090.svc.cluster.local 
```

## Telemetry Configuration

### Introduction

The telemetry configuration in Tracardi allows for monitoring and logging various metrics and logs related to the
system's performance and operations. This feature is currently experimental and is disabled by default. You can safely
remove this section from your custom `values.yaml` file.

### Configuration Fields

The `telemetry` section in the `values.yaml` file includes several fields to configure the telemetry settings. Here’s a
detailed breakdown of each field:

```yaml
telemetry:
  disabled: true  # Whether telemetry is disabled
  name: "tracardi"  # The name for telemetry
  log_level: "info"  # The logging level for telemetry
  export:
    endpoint: ""  # Endpoint for exporting telemetry data
    headers: ""  # Headers to use when exporting telemetry data
    metrics: ""  # Metrics configuration for telemetry
    logs: ""  # Logs configuration for telemetry
    attributes: ""  # Attributes for telemetry
    time_out: 30000  # Timeout for telemetry export in milliseconds
    delay: 5000  # Delay for telemetry export in milliseconds
    batch_size: 512  # Batch size for telemetry export
```

### Explanation of Fields

| Field             | Description                                      |
|-------------------|--------------------------------------------------|
| **disabled**      | Indicates whether telemetry is disabled.         |
| **name**          | The name used for telemetry identification.      |
| **log_level**     | The logging level for telemetry.                 |
| **export**        | Export configuration for telemetry data.         |
| **endpoint**      | The endpoint URL where telemetry data will be exported. |
| **headers**       | Headers to include when exporting telemetry data. |
| **metrics**       | Configuration for exporting metrics.             |
| **logs**          | Configuration for exporting logs.                |
| **attributes**    | Attributes to include in the telemetry data.     |
| **time_out**      | Timeout duration for exporting telemetry data.   |
| **delay**         | Delay between telemetry export operations.       |
| **batch_size**    | The number of telemetry entries to include in each export batch. |

## Load Balancer Configuration

### Introduction

The load balancer configuration section in the `values.yaml` file is used to set up a load balancer for your Tracardi
installation, particularly when deploying on DigitalOcean. This section includes options to enable or disable the load
balancer and to specify a certificate ID for secure connections.

### Configuration Fields

The `digitalOcean` section includes the following fields:

```yaml
digitalOcean:
  loadBalancer: false  # Whether to use a DigitalOcean load balancer. Set this to true if you need a load balancer
  certId: ""  # Certificate ID for DigitalOcean
```

### Explanation of Fields

| Field             | Description                                                                         |
|-------------------|-------------------------------------------------------------------------------------|
| **loadBalancer**  | Determines whether a load balancer will start.                                      |
| **certId**        | The certificate ID for securing connections through the DigitalOcean load balancer. |

Set digitalOcean.loadBalancer to true if you need a load balancer

Add this to your local `values.yaml`

```yaml
digitalOcean:
  loadBalancer: true
```

## General Tracardi Configuration

### Overview

The general configuration settings for Tracardi govern how the system operates, including multi-tenancy, ID prefixes,
demo mode, system events, and visit handling. Below is a detailed breakdown of each configuration
option.

### Configuration Fields

```yaml
config:
  multiTenant:
    multi: "no"  # Whether multi-tenancy is enabled
  storage: # This part can be removed from the custom file.
    failOver:
      enabled: true  # Whether failover storage is enabled
      size: 1Gi  # Size of the failover storage
  primaryId: "emm-"  # Primary ID prefix for the system, set only once during installation. Emm prefix means use email.main as a merging key during automatic profile merging. This means tracardi will automatically merge profiles when there are 2 profiles with the same email.
  demo: "no"  # Whether demo mode is enabled. Disable on production
  systemEvents: "no"  # Whether system events are enabled.
  enableVisitEnded: "no"  # Whether to enable visit ended events. Will the system register when the visit ends.
  visit:
    close: 1200  # Time in seconds to close a visit after inactivity
```

### Explanation of Fields

| Field                   | Description                                      |
|-------------------------|--------------------------------------------------|
| **multiTenant.multi**   | Indicates whether multi-tenancy is enabled.      |
| **primaryId**           | The primary ID prefix for the system.            |
| **demo**                | Indicates whether demo mode is enabled.          |
| **systemEvents**        | Indicates whether system events are enabled.     |
| **enableVisitEnded**    | Indicates whether visit ended events are enabled.|
| **visit.close**         | The time in seconds to close a visit after inactivity. |

### Example

Here is an example `values.yaml` file with only the necessary fields modified:

```yaml
config:
  multiTenant:
    multi: "yes"  # Enable multi-tenancy
  primaryId: "emm-"  # Set the primary ID prefix
  systemEvents: "no"  # Enable system events
  enableVisitEnded: "no"  # Enable visit ended events
  visit:
    close: 1800  # Set visit close time to 1800 seconds (30 minutes)
```

## Definition of Secrets

### Overview

This section of the configuration file contains all the necessary credentials and secrets required for Tracardi and its
dependencies, including databases and external services. Proper management of these secrets is crucial for the security
and functionality of the system.

### Configuration Fields

```yaml
secrets:
  dockerHub: "tracardi-dockerhub"  # Docker Hub repository name. This is the default value; leave it as it is unless you keep the Docker Hub token somewhere else.

  installation:
    token: "tracardi"  # Installation token. Change to a random value. Keep this secret as you will need it to reinstall or recover the system if any of the indices go missing.
    valueFrom:
      token:
        name: ""  # Name of the secret containing the installation token.
        key: ""  # Key of the installation token in the secret.

  license:
    licenseKey: ""  # License key for the application.
    valueFrom:
      licenseKey:
        name: ""  # Name of the secret containing the license key.
        key: ""  # Key of the license key in the secret.

  tms:
    secretKey: ""  # Secret key for Tenant Management Service (TMS).
    apiKey: ""  # API key for TMS.
    valueFrom:
      secretKey:
        name: ""  # Name of the secret containing the TMS secret key.
        key: ""  # Key of the TMS secret key in the secret.
      apiKey:
        name: ""  # Name of the secret containing the TMS API key.
        key: ""  # Key of the TMS API key in the secret.

  redis:
    password: ""  # Password for Redis.
    valueFrom:
      password:
        name: ""  # Name of the secret containing the Redis password.
        key: ""  # Key of the Redis password in the secret.

  elastic:
    username: "elastic"  # Username for Elasticsearch.
    password: ""  # Password for Elasticsearch.
    valueFrom:
      username:
        name: ""  # Name of the secret containing the Elasticsearch username.
        key: ""  # Key of the Elasticsearch username in the secret.
      password:
        name: ""  # Name of the secret containing the Elasticsearch password.
        key: ""  # Key of the Elasticsearch password in the secret.

  pulsar:
    token: ""  # Token for Pulsar.
    valueFrom:
      token:
        name: ""  # Name of the secret containing the Pulsar token.
        key: ""  # Key of the Pulsar token in the secret.

  mysql:
    username: ""  # Username for MySQL.
    password: ""  # Password for MySQL.
    valueFrom:
      username:
        name: ""  # Name of the secret containing the MySQL username.
        key: ""  # Key of the MySQL username in the secret.
      password:
        name: ""  # Name of the secret containing the MySQL password.
        key: ""  # Key of the MySQL password in the secret.

  maxmind:
    licenseKey: ""  # License key for MaxMind.
    accountId: ""  # Account ID for MaxMind.
    valueFrom:
      licenseKey:
        name: ""  # Name of the secret containing the MaxMind license key.
        key: ""  # Key of the MaxMind license key in the secret.
      accountId:
        name: ""  # Name of the secret containing the MaxMind account ID.
        key: ""  # Key of the MaxMind account ID in the secret.

  mergingToken: "1180015e-38d0-4eb7-8017-40e6a7937659"  # Token used for merging. This should be a random value and should not be changed after installation. Keep it permanent across all your installations.
```

### Explanation of Fields


| Field                   | Description                                                                                                                                                                        | Required                     |
|-------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------|
| **dockerHub**           | Name of the Docker Hub repository.                                                                                                                                                 | yes                          |
| **installation.token**  | Installation token.                                                                                                                                                                | yes                          |
| **license.licenseKey**  | License key for the application.                                                                                                                                                   | no                           |
| **tms.secretKey**       | Secret key for Tenant Management Service (TMS).                                                                                                                                    | if multi-tenant installation |
| **tms.apiKey**          | API key for TMS.                                                                                                                                                                   | if multi-tenant installation |
| **redis.password**      | Password for Redis.                                                                                                                                                                | if authentication enabled    |
| **elastic.username**    | Username for Elasticsearch.                                                                                                                                                        | yes                          |
| **elastic.password**    | Password for Elasticsearch.                                                                                                                                                        | if authentication enabled    |
| **pulsar.token**        | Token for Pulsar.                                                                                                                                                                  | if authentication enabled    |
| **mysql.username**      | Username for MySQL.                                                                                                                                                                | if authentication enabled    |
| **mysql.password**      | Password for MySQL.                                                                                                                                                                | if authentication enabled    |
| **maxmind.licenseKey**  | License key for MaxMind.                                                                                                                                                           | no                           |
| **maxmind.accountId**   | Account ID for MaxMind.                                                                                                                                                            | no                           |
| **mergingToken**        | Token used for hashing data during profile merging. This should be a random value and should not be changed after installation. It must remain permanent across all installations. | yes                          |


## Docker Image Settings

### Overview

The image settings section in the `values.yaml` file is used to configure the API component of Tracardi. This includes
settings for both the private and public APIs, such as Docker image details, replica configurations, logging levels, and
service ports. Proper configuration of these settings ensures the APIs operate efficiently and meet the deployment
requirements.

Private API is Used for communication with GUI while Public for collecting Data.

### Configuration Fields

```yaml
# API configuration
api:
  image:
    repository: tracardi/com-tracardi-api  # Docker repository for the API image
    pullPolicy: IfNotPresent  # Image pull policy
    tag: 0.9.0.3  # Image tag, should be the same for GUI and backend

  private:
    enabled: true  # Whether the private API is enabled
    replicas: 1  # Number of replicas for the private API
    config:
      saveLogs: "yes"  # Whether to save logs
      loggingLevel: "INFO"  # Logging level for the private API
      apiDocs: "yes"  # Whether to enable API documentation
      enableWorkflow: "yes"  # Whether to enable workflows
      enableEventDestinations: "yes"  # Whether to enable event destinations
      enableProfileDestinations: "yes"  # Whether to enable profile destinations
      enableIdentification: "yes"  # Whether to enable identification
      eventPartitioning: "month"  # Event partitioning strategy
      profilePartitioning: "quarter"  # Profile partitioning strategy
      sessionPartitioning: "quarter"  # Session partitioning strategy
    service:
      port: 8686  # Port for the private API service

  public:
    enabled: true  # Whether the public API is enabled
    spread:
      rules:
        topologySpreadConstraints:
          - maxSkew: 1  # Maximum skew for topology spread
            topologyKey: kubernetes.io/hostname  # Topology key for spread constraints
            whenUnsatisfiable: ScheduleAnyway  # Action to take when constraints are unsatisfiable
            labelSelector:
              matchLabels:
                app.kubernetes.io/component: be-fa-public  # Label selector
    replicas: 1  # Number of replicas for the public API
    config:
      saveLogs: "no"  # Whether to save logs
      loggingLevel: "WARNING"  # Logging level for the public API
      apiDocs: "no"  # Whether to enable API documentation
      enableWorkflow: "yes"  # Whether to enable workflows
      enableEventDestinations: "yes"  # Whether to enable event destinations
      enableProfileDestinations: "yes"  # Whether to enable profile destinations
      enableIdentification: "yes"  # Whether to enable identification
      eventPartitioning: "month"  # Event partitioning strategy
      profilePartitioning: "quarter"  # Profile partitioning strategy
      sessionPartitioning: "quarter"  # Session partitioning strategy
    service:
      port: 8585  # Port for the public API service
```

### Explanation of Fields

#### API Image

| Field        | Type   | Description                                         | Default                  |
|--------------|--------|-----------------------------------------------------|--------------------------|
| **repository**| String | Docker repository for the API image.               | `tracardi/com-tracardi-api` |
| **pullPolicy**| String | Image pull policy. Common values are `Always`, `IfNotPresent`, and `Never`. | `IfNotPresent`           |
| **tag**      | String | Image tag, ensuring compatibility between GUI and backend. | `0.9.0.3`                |

#### Private/Public API Configuration

| Field                           | Type    | Description                                                                                     | Default |
|---------------------------------|---------|-------------------------------------------------------------------------------------------------|---------|
| **enabled**                     | Boolean | Enables or disables the private API.                                                            | `true`  |
| **replicas**                    | Integer | Number of replicas for the private API. Use for scaling.                                        | `1`     |
| **config.saveLogs**             | String  | Indicates whether to save logs.                                                                 | `"yes"` |
| **config.loggingLevel**         | String  | Logging level for the private API. Common values are `DEBUG`, `INFO`, `WARNING`, `ERROR`.       | `"INFO"` |
| **config.apiDocs**              | String  | Indicates whether to enable API documentation.                                                  | `"yes"` |
| **config.enableWorkflow**       | String  | Indicates whether to enable workflows.                                                          | `"yes"` |
| **config.enableEventDestinations** | String | Indicates whether to enable event destinations.                                                 | `"yes"` |
| **config.enableProfileDestinations** | String | Indicates whether to enable profile destinations.                                               | `"yes"` |
| **config.enableIdentification** | String  | Indicates whether to enable identification.                                                     | `"yes"` |
| **config.eventPartitioning**    | String  | Strategy for event partitioning. Common values are `day`, `week`, `month`, `quarter`, `year`.   | `"month"` |
| **config.profilePartitioning**  | String  | Strategy for profile partitioning. Common values are `day`, `week`, `month`, `quarter`, `year`. | `"quarter"` |
| **config.sessionPartitioning**  | String  | Strategy for session partitioning. Common values are `day`, `week`, `month`, `quarter`, `year`. | `"quarter"` |
| **service.port**                | Integer | Port for the private API service.                                                               | `8686`  |

### Differences in Configuration of Private and Public API

| Configuration Field       | Private API                       | Public API                        |
|---------------------------|------------------------------------|-----------------------------------|
| **saveLogs**              | yes                                | no                                |
| **loggingLevel**          | INFO                               | WARNING                           |
| **apiDocs**               | yes                                | no                                |
| **service.port**          | 8686                               | 8585                              |
| **topologySpreadConstraints** | Not applicable                     | Configured                        |

## GUI Configuration

### Overview

The GUI configuration section in the `values.yaml` file specifies the settings for the graphical user interface (GUI) of Tracardi. This includes details about the Docker image, replica settings, service ports, and specific configuration options for the console.

### Configuration Fields

```yaml
# GUI configuration
gui:
  image:
    repository: tracardi/tracardi-gui  # Docker repository for the GUI image
    pullPolicy: IfNotPresent  # Image pull policy
    tag: 0.9.0.3  # Image tag, should be the same for GUI and backend

  console:
    enabled: true  # Whether the GUI is enabled
    replicas: 1  # Number of replicas for the GUI
    service:
      port: 8787  # Port for the GUI service
    config:
      mode: "with-deployment"  # Mode for the GUI
      allowUpdatesOnProduction: "no"  # Whether to allow updates on production
```

### Explanation of Fields

| Field                   | Description                                                                           |
|-------------------------|---------------------------------------------------------------------------------------|
| **image.repository**    | Docker repository for the GUI image.                                                  |
| **image.pullPolicy**    | Image pull policy. Common values are `Always`, `IfNotPresent`, and `Never`.           |
| **image.tag**           | Image tag.                                                                            |
| **console.enabled**     | Indicates whether the GUI is enabled.                                                 |
| **console.replicas**    | Number of replicas for the GUI.                                                       |
| **console.service.port**| Port for the GUI service.                                                             |
| **config.mode**         | Mode for the console operation. Available values "with-deployment" or "no-deployment" |
| **config.allowUpdatesOnProduction** | Indicates whether updates are allowed on production.                                  |

## TMS Configuration

### Overview

The Tenant Management Service (TMS) configuration section in the `values.yaml` file specifies the settings for TMS in Tracardi. This includes details about the Docker image, replica settings, logging levels, service ports, and the service name.

### Configuration Fields

```yaml
# TMS configuration
tms:
  image:
    repository: tracardi/tms  # Docker repository for the TMS image
    pullPolicy: IfNotPresent  # Image pull policy
    tag: 0.9.0.3  # Image tag, should be the same for GUI and backend
  docker:
    enabled: true  # Whether Docker is enabled
    replicas: 1  # Number of replicas for TMS
    config:
      loggingLevel: "INFO"  # Logging level for TMS
    service:
      port: 8383  # Port for the TMS service
      name: be-fa-tms-svc  # The name of the TMS service
```

### Explanation of Fields

| Field                   | Description                                                                        |
|-------------------------|------------------------------------------------------------------------------------|
| **image.repository**    | Docker repository for the TMS image.                                               |
| **image.pullPolicy**    | Image pull policy. Common values are `Always`, `IfNotPresent`, and `Never`.        |
| **image.tag**           | Image tag.                                                                         |
| **docker.enabled**      | Indicates whether Docker is enabled for TMS.                                       |
| **docker.replicas**     | Number of replicas for TMS.                                                        |
| **service.port**        | Port on which the TMS service runs.                                                |
| **service.name**        | Name of the TMS service.                                                           |
| **loggingLevel**        | Logging level for TMS.  Common values are `ERROR`, `WARNING`, `INFO`, and `DEBUG`. |

## Worker Configuration

### Overview

The worker configuration section in the `values.yaml` file specifies the settings for various worker components in Tracardi, including background workers, APM (Auto Profile Merging) profiles, and upgrade workers. This configuration includes Docker image details, replica settings, logging levels, and resource limits.

### Configuration Fields

```yaml
# Worker configuration
worker:
  background:
    image:
      repository: tracardi/background-worker  # Docker repository for the background worker image
      tag: 0.9.0.3  # Image tag for the background worker
      pullPolicy: IfNotPresent  # Image pull policy
    enabled: true  # Whether the background worker is enabled
    replicas: 1  # Number of replicas for the background worker
    spread:
      rules:
        topologySpreadConstraints:
          - maxSkew: 1  # Maximum skew for topology spread
            topologyKey: kubernetes.io/hostname  # Topology key for spread constraints
            whenUnsatisfiable: ScheduleAnyway  # Action to take when constraints are unsatisfiable
            labelSelector:
              matchLabels:
                app.kubernetes.io/component: wk-pl-background  # Label selector for spread constraints
    config:
      loggingLevel: "INFO"  # Logging level for the background worker

  apm:
    image:
      repository: tracardi/apm  # Docker repository for the APM image
      tag: 0.9.0.3  # Image tag for the APM
      pullPolicy: IfNotPresent  # Image pull policy
    profile:
      enabled: true  # Whether the APM profile is enabled
      replicas: 1  # Number of replicas for the APM profile
      config:
        loggingLevel: "INFO"  # Logging level for the APM profile

  upgrade:
    image:
      repository: tracardi/update-worker  # Docker repository for the upgrade worker image
      tag: 0.9.0.3  # Image tag for the upgrade worker
      pullPolicy: IfNotPresent  # Image pull policy
    docker:
      enabled: true  # Whether Docker is enabled
      replicas: 1  # Number of replicas for the upgrade worker
      config:
        saveLogs: "no"  # Whether to save logs
        loggingLevel: "INFO"  # Logging level for the upgrade worker
      resources:
        limits:
          memory: 500Mi  # Memory limit for the upgrade worker
          cpu: 500m  # CPU limit for the upgrade worker
```

### Explanation of Fields

| Component          | Field                       | Description                                                                                         |
|--------------------|-----------------------------|-----------------------------------------------------------------------------------------------------|
|**Background**     | image.repository            | Docker repository for the background worker image                                                   |
|                    | image.tag                   | Image tag for the background worker                                                                 |
|                    | image.pullPolicy            | Image pull policy                                                                                   |
|                    | enabled                     | Whether the background worker is enabled                                                            |
|                    | replicas                    | Number of replicas for the background worker                                                        |
|                    | spread.rules.topologySpreadConstraints | Topology spread constraints for the background worker                                               |
|                    | config.loggingLevel         | Logging level for the background worker. Common values are `ERROR`, `WARNING`, `INFO`, and `DEBUG`. |
| **APM**            | image.repository            | Docker repository for the APM image                                                                 |
|                    | image.tag                   | Image tag for the APM                                                                               |
|                    | image.pullPolicy            | Image pull policy.Common values are `Always`, `IfNotPresent`, and `Never`.                          |
|                    | profile.enabled             | Whether the APM profile is enabled                                                                  |
|                    | profile.replicas            | Number of replicas for the APM profile                                                              |
|                    | profile.config.loggingLevel | Logging level for the APM profile                                                                   |
| **Upgrade**        | image.repository            | Docker repository for the upgrade worker image                                                      |
|                    | image.tag                   | Image tag for the upgrade worker                                                                    |
|                    | image.pullPolicy            | Image pull policy                                                                                   |
|                    | docker.enabled              | Whether Docker is enabled for the upgrade worker                                                    |
|                    | docker.replicas             | Number of replicas for the upgrade worker                                                           |
|                    | docker.config.saveLogs      | Whether to save logs                                                                                |
|                    | docker.config.loggingLevel  | Logging level for the upgrade worker                                                                |
|                    | docker.config.resources.limits.memory | Memory limit for the upgrade worker                                                                 |
|                    | docker.config.resources.limits.cpu    | CPU limit for the upgrade worker                                                                    |

## Bridges Configuration

### Overview

The bridges configuration section in the `values.yaml` file specifies the settings for the services responsible for
collecting data from different channels. This includes the queue bridge configuration, detailing Docker image settings,
enabling or disabling the bridge, setting the number of replicas, and logging levels. By default none standard bridges are disabled. You can safely remove this configuration form you local `values.yaml` file.

### Configuration Fields

```yaml
# Bridges configuration for services responsible for collecting data from different channels
bridge:
  queue:
    image:
      repository: tracardi/com-bridge-queue  # Docker repository for the queue bridge image
      tag: 0.9.0.3  # Image tag for the queue bridge
      pullPolicy: IfNotPresent  # Image pull policy
    docker:
      enabled: false  # Whether Docker is enabled for the queue bridge
      replicas: 1  # Number of replicas for the queue bridge
      config:
        loggingLevel: "INFO"  # Logging level for the queue bridge
```

### Explanation of Fields

#### Queue Bridge

| Field                   | Description                                                                                    |
|-------------------------|------------------------------------------------------------------------------------------------|
| **image.repository**    | Docker repository for the queue bridge image.                                                  |
| **image.tag**           | Image tag for the queue bridge.                                                                |
| **image.pullPolicy**    | Image pull policy. Common values are `Always`, `IfNotPresent`, and `Never`.                    |
| **docker.enabled**      | Indicates whether Docker is enabled for the queue bridge.                                      |
| **docker.replicas**     | Number of replicas for the queue bridge.                                                       |
| **docker.config.loggingLevel** | Logging level for the queue bridge. Common values are `ERROR`, `WARNING`, `INFO`, and `DEBUG`. |

## Summary

Please override only the fields that needs to change in you local environment. Here is an example of such local `'values.yaml` file.

```yaml
# Dependencies

elastic:   
  host: elastic-std-svc.elastic-standalone.svc.cluster.local
  schema: http
  authenticate: true

redis:
  host: redis-master.redis.svc.cluster.local
  schema: "redis://"
  authenticate: true

pulsar:
  host: pulsar-proxy.pulsar.svc.cluster.local:6650
  api: http://pulsar-proxy.pulsar.svc.cluster.local:80
  schema: "pulsar://"
  authenticate: true

mysql:
  host: percona-db-pxc-db-haproxy.percona.svc.cluster.local
  schema: "mysql+aiomysql://"
  database: "tracardi"

tmsApi:
  host: be-fa-tms-svc.tracardi-com-090.svc.cluster.local

secrets:
  installation:
    token: "XXXX"
  dockerHub: "tracardi-dockerhub"
  license:
    licenseKey: "XXXX"
  tms:
    secretKey: "XXXX"
    apiKey: "XXXX"
  redis:
    password: "XXXX"
  pulsar:
    token: "XXXX"
  mysql:
    username: "root"
    password: "XXXX"

digitalOcean:
  loadBalancer: true


config:
  multiTenant:
    multi: "yes"
  primaryId: "phm-"  # Use phone as primary ID key, This value should be set only once during installation and never changed

api:
  image:
    tag: 0.9.0.4

  private:
    replicas: 1
    service:
      port: 48686

  public:
    replicas: 1
    service:
      port: 48585

gui:
  image:
    tag: 0.9.0.4
  console:
    service:
      port: 48787
    config:
      mode: "no-deployment"
      allowUpdatesOnProduction: "true"

tms:
  image:
    tag: 0.9.0.4
  docker:
    replicas: 1
    service:
      port: 48383

worker:

  background:
    enabled: true
    image:
      tag: 0.9.0.4
    replicas: 1

  apm:
    image:
      tag: 0.9.0.4
    profile:
      enabled: true
      replicas: 1

  upgrade:
    image:
      tag: 0.9.0.4
    docker:
      enabled: true
      replicas: 1
```