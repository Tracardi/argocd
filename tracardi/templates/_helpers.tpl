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
app.kubernetes.io/name: {{ include "tracardi.name" .ctx }}
app.kubernetes.io/ns-elastic: {{ .ctx.Values.elastic.name }}
app.kubernetes.io/ns-cache: {{ .ctx.Values.redis.name }}
app.kubernetes.io/ns-pulsar: {{ .ctx.Values.pulsar.name }}
app.kubernetes.io/instance: {{ .ctx.Release.Name }}
app.kubernetes.io/version: {{ .ctx.Chart.AppVersion | quote }}
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
- name: ELASTIC_QUERY_TIMEOUT
  value: "120"
- name: REDIS_HOST
  value: {{ .ctx.Values.redis.schema }}{{ .ctx.Values.redis.host }}
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
- name: MYSQL_SCHEMA
  value: {{ .ctx.Values.mysql.schema }}
- name: MYSQL_HOST
  value: {{ .ctx.Values.mysql.host }}
{{ if and .ctx.Values.secrets.mysql.password .ctx.Values.secrets.mysql.username }}
- name: MYSQL_USERNAME
  valueFrom:
    secretKeyRef:
      name: "mysql-secret"
      key: "mysql-username"
- name: MYSQL_PASSWORD
  valueFrom:
    secretKeyRef:
      name: "mysql-secret"
      key: "mysql-password"
{{ else if and .ctx.Values.secrets.mysql.valueFrom.password.name .ctx.Values.secrets.mysql.valueFrom.password.key .ctx.Values.secrets.mysql.valueFrom.username.name .ctx.Values.secrets.mysql.valueFrom.username.key }}
- name: MYSQL_USERNAME
  valueFrom:
    secretKeyRef:
      name: {{ .ctx.Values.secrets.mysql.valueFrom.username.name | quote }}
      key: {{ .ctx.Values.secrets.mysql.valueFrom.username.key | quote }}
- name: MYSQL_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .ctx.Values.secrets.mysql.valueFrom.password.name | quote }}
      key: {{ .ctx.Values.secrets.mysql.valueFrom.password.key | quote }}
{{ end }}
- name: MYSQL_PORT
  value: {{ .ctx.Values.mysql.port | quote }}
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
- name: SOURCE_CACHE_TTL
  value: "2"
- name: SESSION_CACHE_TTL
  value: "2"
- name: EVENT_TAG_CACHE_TTL
  value: "10"
- name: EVENT_VALIDATION_CACHE_TTL
  value: "10"
- name: TRACK_DEBUG
  value: "yes"
- name: TRACARDI_PRO_HOST
  value: "pro.tracardi.com"
- name: TRACARDI_PRO_PORT
  value: "40000"
{{ if .ctx.Values.secrets.installation.token }}
- name: INSTALLATION_TOKEN
  value: {{ .ctx.Values.secrets.installation.token | quote }}
{{ else if and .ctx.Values.secrets.installation.fromValue.token.name .ctx.Values.secrets.installation.fromValue.token.key }}
- name: INSTALLATION_TOKEN
  valueFrom:
    secretKeyRef:
      name: {{ .ctx.Values.secrets.installation.fromValue.token.name | quote }}
      key: {{ .ctx.Values.secrets.installation.fromValue.token.key | quote }}
{{ end }}
- name: AUTO_PROFILE_MERGING
  value: {{ .ctx.Values.secrets.mergingToken | quote }}
{{ if .ctx.Values.config.storage.failOver.enabled }}
- name: ENABLE_PULSAR_FAIL_OVER_DB
  value: "yes"
{{ end }}
- name: EVENT_PARTITIONING
  value: {{ .ctx.Values.api.public.config.eventPartitioning | quote }}
- name: PROFILE_PARTITIONING
  value: {{ .ctx.Values.api.public.config.profilePartitioning | quote }}
- name: SESSION_PARTITIONING
  value: {{ .ctx.Values.api.public.config.sessionPartitioning | quote }}
- name: CLOSE_VISIT_AFTER
  value: {{ .ctx.Values.config.visit.close | quote }}

{{- end -}}
