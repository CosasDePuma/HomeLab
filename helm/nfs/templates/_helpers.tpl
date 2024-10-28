# Name
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{- define "shortName" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 15 | trimSuffix "-" }}
{{- end -}}

# Labels
{{- define "labels" -}}
app: {{ include "name" . }}
infrastructure: 'Homelab'
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/name: {{ include "name" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.labels }}
{{ . | toYaml }}
{{- end }}
{{- end }}

# Annotations
{{- define "annotations" -}}
{{- with .Values.annotations}}
{{- . | toYaml }}
{{- end}}
{{- end }}

# Metadata
{{- define "metadata" -}}
labels:
{{- include "labels" . | nindent 2 }}
annotations:
{{- include "annotations" . | nindent 2 }}
{{- end }}