{{/*
Expand the name of the chart.
*/}}
{{- define "airembr.name" -}}
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
{{- define "airembr.chart" -}}
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
{{- define "airembr.labels" -}}
helm.sh/chart: {{ include "airembr.chart" .ctx }}
app.kubernetes.io/name: {{ include "airembr.name" .ctx }}
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
{{- define "airembr.selectorLabels" -}}
app.kubernetes.io/name: {{ include "airembr.name" .ctx }}
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
{{- define "airembr.podLabels" -}}
helm.sh/chart: {{ include "airembr.chart" .ctx }}
app: {{ include "airembr.name" .ctx }}
version: {{ .ctx.Chart.AppVersion | quote }}
app.kubernetes.io/name: {{ include "airembr.name" .ctx }}
app.kubernetes.io/version: {{ .ctx.Chart.AppVersion | quote }}
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
{{- define "airembr.env" -}}

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
{{ if .ctx.Values.mysql.schema.async }}
- name: MYSQL_SCHEMA_ASYNC
  value: {{ .ctx.Values.mysql.schema.async }}
{{ end }}
{{ if .ctx.Values.mysql.schema.sync }}
- name: MYSQL_SCHEMA_SYNC
  value: {{ .ctx.Values.mysql.schema.sync }}
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

{{ if .ctx.Values.pulsar.enabled }}
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
{{ end }}

{{ if and .ctx.Values.config.adapter.queue }}
- name: QUEUE_ADAPTER
  value: {{ .ctx.Values.config.adapter.queue | quote }}
{{ end }}

{{/* KAFKA */}}
{{ if .ctx.Values.kafka.enabled }}

{{/* KAFKA SERVERS */}}
{{- if .ctx.Values.kafka.servers }}
- name: KAFKA_SERVERS
  value: {{ .ctx.Values.kafka.servers | quote }}
{{- end }}

{{/* KAFKA PROTOCOL */}}
{{- if .ctx.Values.kafka.security_protocol }}
- name: KAFKA_SECURITY_PROTOCOL
  value: {{ .ctx.Values.kafka.security_protocol | quote }}
{{- end }}

{{/* KAFKA SASL MECHANISM */}}
{{- if .ctx.Values.kafka.sasl.mechanism }}
- name: KAFKA_SASL_MECHANISM
  value: {{ .ctx.Values.kafka.sasl.mechanism | quote }}
{{- end }}

{{/* KAFKA USERNAME */}}
{{ if and .ctx.Values.secrets.kafka.valueFrom.sasl_plain_username.name .ctx.Values.secrets.kafka.valueFrom.sasl_plain_username.key }}
- name: KAFKA_SASL_PLAIN_USERNAME
  valueFrom:
    secretKeyRef:
      name: {{ .ctx.Values.secrets.kafka.valueFrom.sasl_plain_username.name | quote }}
      key: {{ .ctx.Values.secrets.kafka.valueFrom.sasl_plain_username.key | quote }}
{{ else if and .ctx.Values.secrets.kafka.sasl_plain_username }}
- name: KAFKA_SASL_PLAIN_USERNAME
  value: {{ .ctx.Values.secrets.kafka.sasl_plain_username | quote }}
{{ end }}

{{/* KAFKA PASSWORD */}}
{{ if and .ctx.Values.secrets.kafka.valueFrom.sasl_plain_password.name .ctx.Values.secrets.kafka.valueFrom.sasl_plain_password.key }}
- name: KAFKA_SASL_PLAIN_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .ctx.Values.secrets.kafka.valueFrom.sasl_plain_password.name | quote }}
      key: {{ .ctx.Values.secrets.kafka.valueFrom.sasl_plain_password.key | quote }}
{{ else if and .ctx.Values.secrets.kafka.sasl_plain_password }}
- name: KAFKA_SASL_PLAIN_PASSWORD
  value: {{ .ctx.Values.secrets.kafka.sasl_plain_password | quote }}
{{ end }}

{{ end }}

{{ if and .ctx.Values.secrets.tms.apiKey .ctx.Values.secrets.tms.secretKey }}
- name: MULTI_TENANT
  value: {{ .ctx.Values.config.tenant.multi | quote }}
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


{{- if .ctx.Values.starrocks }}
{{- if .ctx.Values.starrocks.host }}
- name: STARROCKS_HOST
  value: {{ .ctx.Values.starrocks.host | quote }}
{{- end -}}

{{- if .ctx.Values.secrets.starrocks.username }}
- name: STARROCKS_USERNAME
  value: {{ .ctx.Values.secrets.starrocks.username | quote }}
{{- end -}}

{{- if .ctx.Values.secrets.starrocks.password }}
- name: STARROCKS_PASSWORD
  value: {{ .ctx.Values.secrets.starrocks.password | quote }}
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