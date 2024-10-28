---
# =================================================
#   Names
# =================================================

# --- | name
# Helper function that returns the name of the chart.
# It uses the `name` value if it is set, otherwise it uses `Chart.Name`.
# It truncates the name to 63 characters and removes any trailing hyphens.
{{- define "name" -}}
{{- .Values.metadata.name | default .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end -}}

# --- | svcName
# Helper function that returns the name of the chart being valid for a service name.
# It uses the `name` value if it is set, otherwise it uses `Chart.Name`.
# It truncates the name to 15 characters and removes any trailing hyphens.
{{- define "svcName" -}}
{{- include "name" . | trunc 15 | trimSuffix "-" }}
{{- end -}}

# =================================================
#   Labels / Annotations
# =================================================

# --- | labels  # FIXME: Merge ".Values.metadata.labels" with my default labels using a merge function
# Helper function that returns common labels for the chart.
# It includes the following labels:
# - app: The name of the chart.
# - infrastructure: The infrastructure where the chart is deployed.
# - helm.sh/chart: The name and version of the chart.
# - app.kubernetes.io/name: The name of the chart.
# - app.kubernetes.io/version: The version of the chart.
# - app.kubernetes.io/instance: The name of the release.
# - app.kubernetes.io/managed-by: The name of the release service (Helm).
# It also includes any additional labels defined as the `labels` value.
{{- define "labels" -}}
app: {{ include "name" . | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/name: {{ include "name" . | quote }}
app.kubernetes.io/part-of: {{ .Chart.Name | quote }}
{{ with .Chart.AppVersion }}
app.kubernetes.io/version: {{ . | quote }}
{{- end -}}
helm.sh/chart: "{{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}"
wtf.kike/project: "Homelab"
{{ with .Values.metadata.labels }}
{{- . | toYaml }}
{{- end }}
{{- end -}}

# --- | annotations
# Helper function that returns common annotations for the chart.
# It includes any additional annotations defined as the `annotations` value.
{{- define "annotations" -}}
{{- with .Values.metadata.annotations }}
{{- . | toYaml }}
{{- end }}
{{- end -}}
...
