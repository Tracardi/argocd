{{/*
Expand the name of the chart.
*/}}
{{- define "tracardi.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tracardi.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "tracardi.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create the name of the service account to use
*/}}
{{- define "tracardi.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "tracardi.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Resource labels
Params:
  ctx = . context
  component = component name (optional)
*/}}
{{- define "tracardi.labels" -}}
helm.sh/chart: {{ include "tracardi.chart" .ctx }}
app.kubernetes.io/name: {{ include "tracardi.name" .ctx }}
app.kubernetes.io/instance: {{ .ctx.Release.Name }}


{{- if .component }}
app.kubernetes.io/component: {{ .component }}
{{- end }}
{{- if .ctx.Chart.AppVersion }}
app.kubernetes.io/version: {{ .ctx.Chart.AppVersion | quote }}
service.istio.io/canonical-revision: {{ .ctx.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .ctx.Release.Service }}
{{- end -}}

{{/*
Service selector labels
Params:
  ctx = . context
  component = name of the component
*/}}
{{- define "tracardi.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tracardi.name" .ctx }}
app.kubernetes.io/instance: {{ .ctx.Release.Name }}

{{- if .component }}
app.kubernetes.io/component: {{ .component }}
{{- end }}
{{- end }}

{{/* Image
Params:
  repo = type of image
  policy = pullPolicy type
  ctx = . context
*/}}

{{- define "tracardi.image" -}}
image: "{{ .repo }}:{{ .tag }}"
imagePullPolicy: {{ .policy }}
{{- end }}

{{/*
POD labels
Params:
  ctx = . context
  component = name of the component
*/}}
{{- define "tracardi.podLabels" -}}
helm.sh/chart: {{ include "tracardi.chart" .ctx }}
app: {{ include "tracardi.name" .ctx }}
version: {{ .ctx.Chart.AppVersion | quote }}
app.kubernetes.io/name: {{ include "tracardi.name" .ctx }}
app.kubernetes.io/version: {{ .ctx.Chart.AppVersion | quote }}
app.kubernetes.io/ns-elastic: {{ .ctx.Values.elastic.name }}
app.kubernetes.io/ns-cache: {{ .ctx.Values.redis.name }}
app.kubernetes.io/ns-pulsar: {{ .ctx.Values.pulsar.name }}
app.kubernetes.io/instance: {{ .ctx.Release.Name }}
app.kubernetes.io/managed-by: {{ .ctx.Release.Service }}
{{- if .component }}
app.kubernetes.io/component: {{ .component }}
{{- end }}
{{- end }}

{{/*
Common Env Var
Params:
  ctx = . context
  license = name of secret containing the license
*/}}
{{- define "tracardi.env" -}}

{{- if and (not .nolicense) .ctx.Values.secrets.license.licenseKey }}
- name: LICENSE
  valueFrom:
    secretKeyRef:
      name: "tracardi-license"
      key: "license-key"
{{ else if and (not .nolicense) .ctx.Values.secrets.license.valueFrom.licenseKey.name .ctx.Values.secrets.license.valueFrom.licenseKey.key }}
- name: LICENSE
  valueFrom:
    secretKeyRef:
      name: {{ .ctx.Values.secrets.license.valueFrom.licenseKey.name }}
      key: {{ .ctx.Values.secrets.license.valueFrom.licenseKey.key }}
{{- end }}

- name: ELASTIC_SCHEME
  value: {{ .ctx.Values.elastic.schema | quote }}
- name: ELASTIC_HOST
  value: {{ .ctx.Values.elastic.host }}
{{ if and .ctx.Values.secrets.elastic.password .ctx.Values.secrets.elastic.username }}
- name: ELASTIC_HTTP_AUTH_USERNAME
  valueFrom:
    secretKeyRef:
      name: "elastic-secret"
      key: "elastic-username"
- name: ELASTIC_HTTP_AUTH_PASSWORD
  valueFrom:
    secretKeyRef:
      name: "elastic-secret"
      key: "elastic-password"
{{ else if and .ctx.Values.secrets.elastic.valueFrom.password.name .ctx.Values.secrets.elastic.valueFrom.password.key .ctx.Values.secrets.elastic.valueFrom.username.name .ctx.Values.secrets.elastic.valueFrom.username.key }}
- name: ELASTIC_HTTP_AUTH_USERNAME
  valueFrom:
    secretKeyRef:
      name: {{ .ctx.Values.secrets.elastic.valueFrom.username.name | quote  }}
      key: {{ .ctx.Values.secrets.elastic.valueFrom.username.key | quote  }}
- name: ELASTIC_HTTP_AUTH_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .ctx.Values.secrets.elastic.valueFrom.password.name | quote }}
      key: {{ .ctx.Values.secrets.elastic.valueFrom.password.key | quote }}
{{ end }}
- name: ELASTIC_PORT
  value: {{ .ctx.Values.elastic.port | quote }}
- name: ELASTIC_VERIFY_CERTS
  value: {{ .ctx.Values.elastic.verifyCerts | quote }}
{{ if .ctx.Values.elastic.index }}
- name: ELASTIC_INDEX_SHARDS
  value: {{ .ctx.Values.elastic.index.shards | quote }}
- name: ELASTIC_INDEX_REPLICAS
  value: {{ .ctx.Values.elastic.index.replicas | quote }}
{{ end }}
- name: ELASTIC_QUERY_TIMEOUT
  value: "120"
- name: REDIS_HOST
  value: {{ .ctx.Values.redis.schema }}{{ .ctx.Values.redis.host }}
- name: REDIS_PORT
  value: {{ .ctx.Values.redis.port | quote }}
{{ if and .ctx.Values.secrets.redis.password }}
- name: REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      name: "redis-secret"
      key: "redis-password"
{{ else if and .ctx.Values.secrets.redis.valueFrom.password.name .ctx.Values.secrets.redis.valueFrom.password.key }}
- name: REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .ctx.Values.secrets.redis.valueFrom.password.name | quote }}
      key: {{ .ctx.Values.secrets.redis.valueFrom.password.key | quote }}
{{ end }}
{{ if .ctx.Values.mysql.schema }}
- name: MYSQL_SCHEMA
  value: {{ .ctx.Values.mysql.schema }}
{{ end }}
{{ if .ctx.Values.mysql.host }}
- name: MYSQL_HOST
  value: {{ .ctx.Values.mysql.host }}
{{ end }}

{{ if .ctx.Values.secrets.mysql.username }}
- name: MYSQL_USERNAME
  value: {{ .ctx.Values.secrets.mysql.username | quote }}
{{ else if and .ctx.Values.secrets.mysql.valueFrom.username.name .ctx.Values.secrets.mysql.valueFrom.username.key }}
- name: MYSQL_USERNAME
  valueFrom:
    secretKeyRef:
      name: {{ .ctx.Values.secrets.mysql.valueFrom.username.name | quote }}
      key: {{ .ctx.Values.secrets.mysql.valueFrom.username.key | quote }}
{{ end }}

{{ if .ctx.Values.secrets.mysql.password }}
- name: MYSQL_PASSWORD
  value: {{ .ctx.Values.secrets.mysql.password | quote }}
{{ else if and .ctx.Values.secrets.mysql.valueFrom.password.name .ctx.Values.secrets.mysql.valueFrom.password.key  }}
- name: MYSQL_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .ctx.Values.secrets.mysql.valueFrom.password.name | quote }}
      key: {{ .ctx.Values.secrets.mysql.valueFrom.password.key | quote }}
{{ end }}

- name: MYSQL_PORT
  value: {{ .ctx.Values.mysql.port | quote }}
- name: MYSQL_DATABASE
  value: {{ .ctx.Values.mysql.database }}

{{- if .ctx.Values.mysql.pool}}
- name: MYSQL_POOL_SIZE
  value: {{ .ctx.Values.mysql.pool.size | quote }}
- name: MYSQL_POOL_MAX_OVERFLOW
  value: {{ .ctx.Values.mysql.pool.maxOverflow | quote }}
- name: MYSQL_POOL_TIMEOUT
  value: {{ .ctx.Values.mysql.pool.timeout | quote }}
- name: MYSQL_POOL_RECYCLE
  value: {{ .ctx.Values.mysql.pool.recycle | quote }}
{{- end }}

- name: PRIMARY_ID
  value: {{ .ctx.Values.config.primaryId }}
- name: PULSAR_HOST
  value: {{ .ctx.Values.pulsar.schema }}{{ .ctx.Values.pulsar.host }}
- name: PULSAR_API
  value: {{ .ctx.Values.pulsar.api }}
- name: PULSAR_CLUSTER
  value: {{ .ctx.Values.pulsar.cluster_name }}
{{ if and .ctx.Values.secrets.pulsar.token }}
- name: PULSAR_AUTH_TOKEN
  valueFrom:
    secretKeyRef:
      name: "pulsar-secret"
      key: "pulsar-token"
{{ else if and .ctx.Values.secrets.pulsar.valueFrom.token.name .ctx.Values.secrets.pulsar.valueFrom.token.key }}
- name: PULSAR_AUTH_TOKEN
  valueFrom:
    secretKeyRef:
      name: {{ .ctx.Values.secrets.pulsar.valueFrom.token.name | quote }}
      key: {{ .ctx.Values.secrets.pulsar.valueFrom.token.key | quote }}
{{ end }}
{{ if not .ctx.Values.pulsar.enabled }}
- name: PULSAR_DISABLED
  value: "yes"
{{ end }}
{{ if and .ctx.Values.secrets.tms.apiKey .ctx.Values.secrets.tms.secretKey }}
- name: MULTI_TENANT
  value: {{ .ctx.Values.config.multiTenant.multi | quote }}
- name: MULTI_TENANT_MANAGER_URL
  value: http://{{ .ctx.Values.tmsApi.host }}:{{ .ctx.Values.tms.docker.service.port }}
{{ if and .ctx.Values.secrets.tms.apiKey }}
- name: MULTI_TENANT_MANAGER_API_KEY
  valueFrom:
    secretKeyRef:
      name: "tms"
      key: "api-key"
{{ else if and .ctx.Values.secrets.tms.valueFrom.apiKey.name .ctx.Values.secrets.tms.valueFrom.apiKey.key }}
- name: MULTI_TENANT_MANAGER_API_KEY
  valueFrom:
    secretKeyRef:
      name: {{ .ctx.Values.secrets.tms.valueFrom.apiKey.name | quote }}
      key: {{ .ctx.Values.secrets.tms.valueFrom.apiKey.key | quote }}
{{ end }}
{{ end }}
{{ if and .ctx.Values.secrets.maxmind.licenseKey .ctx.Values.secrets.maxmind.accountId }}
- name: MAXMIND_LICENSE_KEY
  value: {{ .ctx.Values.secrets.maxmind.licenseKey | quote}}
- name: MAXMIND_ACCOUNT_ID
  value: {{ .ctx.Values.secrets.maxmind.accountId | quote }}
{{ else if and .ctx.Values.secrets.maxmind.valueFrom.licenseKey.name .ctx.Values.secrets.maxmind.valueFrom.licenseKey.key .ctx.Values.secrets.maxmind.valueFrom.accountId.name .ctx.Values.secrets.maxmind.valueFrom.accountId.key }}
- name: MAXMIND_LICENSE_KEY
  valueFrom:
    secretKeyRef:
      name: {{ .ctx.Values.secrets.maxmind.valueFrom.licenseKey.name | quote }}
      key: {{ .ctx.Values.secrets.maxmind.valueFrom.licenseKey.key | quote }}
- name: MAXMIND_ACCOUNT_ID
  valueFrom:
    secretKeyRef:
      name: {{ .ctx.Values.secrets.maxmind.valueFrom.accountId.name | quote }}
      key: {{ .ctx.Values.secrets.maxmind.valueFrom.accountId.key | quote }}
{{end}}
- name: TRACK_DEBUG
  value: "yes"
- name: SYSTEM_EVENTS
  value: {{ .ctx.Values.config.systemEvents.enabled | quote }}
- name: ENABLE_VISIT_ENDED
  value: {{ .ctx.Values.config.systemEvents.collectVisitEnded | quote }}
{{ if .ctx.Values.secrets.installation.token }}
- name: INSTALLATION_TOKEN
  value: {{ .ctx.Values.secrets.installation.token | quote }}
{{ else if and .ctx.Values.secrets.installation.valueFrom.token.name .ctx.Values.secrets.installation.valueFrom.token.key }}
- name: INSTALLATION_TOKEN
  valueFrom:
    secretKeyRef:
      name: {{ .ctx.Values.secrets.installation.valueFrom.token.name | quote }}
      key: {{ .ctx.Values.secrets.installation.valueFrom.token.key | quote }}
{{ end }}
- name: AUTO_PROFILE_MERGING
  value: {{ .ctx.Values.secrets.mergingToken | quote }}

- name: EVENT_PARTITIONING
  value: {{ .ctx.Values.api.public.config.eventPartitioning | quote }}
- name: PROFILE_PARTITIONING
  value: {{ .ctx.Values.api.public.config.profilePartitioning | quote }}
- name: SESSION_PARTITIONING
  value: {{ .ctx.Values.api.public.config.sessionPartitioning | quote }}
- name: ENTITY_PARTITIONING
  value: {{ .ctx.Values.api.public.config.entityPartitioning | quote }}
- name: CLOSE_VISIT_AFTER
  value: {{ .ctx.Values.config.visit.close | quote }}

{{- if .ctx.Values.telemetry }}
- name: OTEL_SDK_DISABLED
  value: {{ .ctx.Values.telemetry.disabled | quote }}
- name: OTEL_SERVICE_NAME
  value: {{ .ctx.Values.telemetry.name | quote }}
- name: OTEL_LOG_LEVEL
  value: {{ .ctx.Values.telemetry.log_level | quote }}
- name: OTEL_BLRP_SCHEDULE_DELAY
  value: {{ .ctx.Values.telemetry.export.delay | quote }}
- name: OTEL_BSP_SCHEDULE_DELAY
  value: {{ .ctx.Values.telemetry.export.delay | quote }}
- name: OTEL_BSP_EXPORT_TIMEOUT
  value: {{ .ctx.Values.telemetry.export.time_out | quote }}
- name: OTEL_BLRP_EXPORT_TIMEOUT
  value: {{ .ctx.Values.telemetry.export.time_out | quote }}
- name: OTEL_BLRP_MAX_EXPORT_BATCH_SIZE
  value: {{ .ctx.Values.telemetry.export.batch_size | quote }}
- name: OTEL_BSP_MAX_EXPORT_BATCH_SIZE
  value: {{ .ctx.Values.telemetry.export.batch_size | quote }}
{{ if .ctx.Values.telemetry.export.endpoint }}
- name: OTEL_EXPORTER_OTLP_ENDPOINT
  value: {{ .ctx.Values.telemetry.export.endpoint | quote }}
{{- end -}}
{{ if .ctx.Values.telemetry.export.headers }}
- name: OTEL_EXPORTER_OTLP_HEADERS
  value: {{ .ctx.Values.telemetry.export.headers | quote }}
{{- end -}}
{{ if .ctx.Values.telemetry.export.metrics }}
- name: OTEL_METRICS_EXPORTER
  value: {{ .ctx.Values.telemetry.export.metrics | quote }}
{{- end -}}
{{ if .ctx.Values.telemetry.export.logs }}
- name: OTEL_LOGS_EXPORTER
  value: {{ .ctx.Values.telemetry.export.logs | quote }}
{{- end -}}
{{ if .ctx.Values.telemetry.export.attributes }}
- name: OTEL_RESOURCE_ATTRIBUTES
  value: {{ .ctx.Values.telemetry.export.attributes | quote }}
{{- end -}}
{{- end -}}

{{ if and .ctx.Values.config.apm.identificationEventProperty (not (empty .ctx.Values.config.apm.identificationEventProperty))}}
- name: IDENTIFICATION_EVENT_PROPERTY
  value: {{ .ctx.Values.config.apm.identificationEventProperty | quote }}
{{- end -}}
{{ if and .ctx.Values.config.apm.tipType (not (empty .ctx.Values.config.apm.tipType))}}
- name: IDENTIFICATION_POINT_TYPE
  value: {{ .ctx.Values.config.apm.tipType | quote }}
{{- end -}}
{{ if and .ctx.Values.config.apm.eventType (not (empty .ctx.Values.config.apm.eventType))}}
- name: IDENTIFICATION_EVENT_TYPE
  value: {{ .ctx.Values.config.apm.eventType | quote }}
{{- end -}}

{{ if .ctx.Values.config.features.enableEventDestinations }}
- name: ENABLE_EVENT_DESTINATIONS
  value: {{ .ctx.Values.config.features.enableEventDestinations | quote }}
{{- end -}}

{{ if .ctx.Values.config.features.enableProfileDestinations }}
- name: ENABLE_PROFILE_DESTINATIONS
  value: {{ .ctx.Values.config.features.enableProfileDestinations | quote }}
{{- end -}}

{{ if .ctx.Values.config.features.enableAudiences }}
- name: ENABLE_AUDIENCES
  value: {{ .ctx.Values.config.features.enableAudiences | quote }}
{{- end -}}

{{ if and .ctx.Values.worker.workflow.enabled  .ctx.Values.config.features.enableWorkflow }}
- name: ENABLE_WORKFLOW
  value: {{ .ctx.Values.config.features.enableWorkflow | quote }}
{{- end -}}

{{ if .ctx.Values.config.features.enableEventValidation }}
- name: ENABLE_EVENT_VALIDATION
  value: {{ .ctx.Values.config.features.enableEventValidation | quote }}
{{- end -}}

{{ if .ctx.Values.config.features.enableEventReshaping }}
- name: ENABLE_EVENT_RESHAPING
  value: {{ .ctx.Values.config.features.enableEventReshaping | quote }}
{{- end -}}

{{ if .ctx.Values.config.features.enableEventMapping }}
- name: ENABLE_EVENT_MAPPING
  value: {{ .ctx.Values.config.features.enableEventMapping | quote }}
{{- end -}}

{{ if .ctx.Values.config.features.enableEventToProfileMapping }}
- name: ENABLE_EVENT_TO_PROFILE_MAPPING
  value: {{ .ctx.Values.config.features.enableEventToProfileMapping | quote }}
{{- end -}}

{{ if .ctx.Values.config.features.enableDataCompliance }}
- name: ENABLE_DATA_COMPLIANCE
  value: {{ .ctx.Values.config.features.enableDataCompliance | quote }}
{{- end -}}

{{ if .ctx.Values.config.features.enableEventSourceCheck }}
- name: ENABLE_EVENT_SOURCE_CHECK
  value: {{ .ctx.Values.config.features.enableEventSourceCheck | quote }}
{{- end -}}

{{ if .ctx.Values.config.features.enableIdentificationPoints }}
- name: ENABLE_IDENTIFICATION_POINTS
  value: {{ .ctx.Values.config.features.enableIdentificationPoints | quote }}
{{- end -}}

{{ if .ctx.Values.config.eff.enableLateProfileBinding }}
- name: EFF_LATE_PROFILE_BINDING
  value: {{ .ctx.Values.config.eff.enableLateProfileBinding | quote }}
{{- end -}}

{{ if .ctx.Values.config.cache.keepProfileInCacheFor }}
- name: KEEP_PROFILE_IN_CACHE_FOR
  value: "{{ .ctx.Values.config.cache.keepProfileInCacheFor }}"
{{- end -}}

{{ if .ctx.Values.config.cache.keepSessionInCacheFor }}
- name: KEEP_SESSION_IN_CACHE_FOR
  value: "{{ .ctx.Values.config.cache.keepSessionInCacheFor }}"
{{- end -}}


{{ if .ctx.Values.config.monitorPropertyChange }}
- name: SYSTEM_EVENTS_FOR_PROPERTY_CHANGE
  value: "{{ .ctx.Values.config.monitorPropertyChange }}"
{{- end -}}



{{- if .ctx.Values.starrocks }}
{{- if .ctx.Values.starrocks.host }}
- name: STARROCKS_HOST
  value: {{ .ctx.Values.starrocks.host | quote }}
{{- end -}}

{{- if .ctx.Values.starrocks.username }}
- name: STARROCKS_USERNAME
  value: {{ .ctx.Values.starrocks.username | quote }}
{{- end -}}

{{- if .ctx.Values.starrocks.password }}
- name: STARROCKS_PASSWORD
  value: {{ .ctx.Values.starrocks.password | quote }}
{{- end -}}

{{- if .ctx.Values.starrocks.schema }}
- name: STARROCKS_SCHEMA
  value: {{ .ctx.Values.starrocks.schema | quote }}
{{- end -}}

{{- if .ctx.Values.starrocks.schemaSync }}
- name: STARROCKS_SCHEMA_SYNC
  value: {{ .ctx.Values.starrocks.schemaSync | quote }}
{{- end -}}

{{- if .ctx.Values.starrocks.port }}
- name: STARROCKS_PORT
  value: "{{ .ctx.Values.starrocks.port }}"
{{- end -}}

{{- if .ctx.Values.starrocks.database }}
- name: STARROCKS_DATABASE
  value: {{ .ctx.Values.starrocks.database | quote }}
{{- end -}}

{{- if .ctx.Values.starrocks.echo }}
- name: STARROCKS_ECHO
  value: {{ .ctx.Values.starrocks.echo | quote }}
{{- end -}}
{{- end -}}



{{- end -}}

# templates/_helpers.tpl

{{/*
Node affinity helper with nested path support and error checking
Usage: include "chart.nodeAffinity" (dict "context" . "path" "api.private")
*/}}
{{- define "chart.nodeAffinity" -}}
{{- $root := .context.Values }}
{{- $affinity := $root }}
{{- $valid := true }}
{{- range splitList "." .path }}
  {{- if $affinity }}
    {{- $affinity = get $affinity . }}
  {{- else }}
    {{- $valid = false }}
  {{- end }}
{{- end }}
{{- if and $valid $affinity }}
  {{- if kindIs "map" $affinity }}
    {{- if hasKey $affinity "nodeAffinity" }}
      {{- with $affinity.nodeAffinity }}
affinity:
  nodeAffinity:
        {{- with .required }}
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        {{- toYaml . | nindent 8 }}
        {{- end }}
        {{- with .preferred }}
    preferredDuringSchedulingIgnoredDuringExecution:
        {{- range . }}
    - weight: {{ .weight }}
      preference:
        matchExpressions:
        - key: {{ .key }}
          operator: {{ .operator }}
          values:
          {{- toYaml .values | nindent 10 }}
        {{- end }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}
{{- end }}