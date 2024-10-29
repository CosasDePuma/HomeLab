---
# =================================================
#   Names
# =================================================

# --- | name
# Helper function that returns the name of the chart.
# It uses the `name` value if it is set, otherwise it uses `Chart.name`.
# It truncates the name to 63 characters and removes any trailing hyphens.
{{- define "name" -}}
{{- .Values.metadata.name | default "Test" | trunc 63 | trimSuffix "-" | lower }}
{{- end -}}

# --- | svcName
# Helper function that returns the name of the chart being valid for a service name.
# It uses the `name` value if it is set, otherwise it uses `Chart.name`.
# It truncates the name to 15 characters and removes any trailing hyphens.
{{- define "svcName" -}}
{{- include "name" . | trunc 15 | trimSuffix "-" }}
{{- end -}}

# =================================================
#   Labels / Annotations
# =================================================

# --- | labels
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
{{- merge (include "labels_defaults" . | fromYaml) .Values.metadata.labels | toYaml | nindent 0 }}
{{- end -}}
{{- define "labels_defaults" -}}
app: {{ include "name" . | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
app.kubernetes.io/managed-by: {{ .Release.Name | quote }}
app.kubernetes.io/name: {{ include "name" . | quote }}
app.kubernetes.io/part-of: {{ .Chart.name | quote }}
{{- with .Chart.appversion }}
app.kubernetes.io/version: {{ . | quote }}
{{- end }}
helm.sh/chart: "{{ .Chart.name }}-{{ .Chart.version | replace "+" "_" }}"
wtf.kike/project: "Homelab"
{{- end -}}

# --- | annotations
# Helper function that returns common annotations for the chart.
# It includes any additional annotations defined as the `annotations` value.
{{- define "annotations" -}}
{{- with .Values.metadata.annotations | default (dict ) }}
{{ . | toYaml | nindent 0 }}
{{- end }}
{{- end -}}

# --- | merge: values
# Helper function to merge two YAML definitions.
{{- define "context" -}}
{{- $original := first . -}}
{{- $overrides := tpl (include (index . 1) $original) $original | fromYaml -}}
{{ merge (dict ) $original (dict "Values" $overrides) | toYaml }}
{{- end -}}
...
