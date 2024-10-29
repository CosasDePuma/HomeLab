{{- define "configmap.tpl" -}}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: "{{ include "name" . }}"
  labels:
    {{- include "labels" . | nindent 4 }}
    {{- with .Values.configmap.labels | default (dict ) }}
    {{- . | toYaml | nindent 4 }}
    {{- end }}
  annotations:
    {{- include "annotations" . | nindent 4 }}
    {{- with .Values.configmap.annotations | default (dict ) }}
    {{- . | toYaml | nindent 4 }}
    {{- end }}
{{- with .Values.configmap.binaryData | default (dict ) }}
binaryData:
  {{- range $name, $contents := . }}
  {{- $name | nindent 2 }}: |-
    {{- $contents | toYaml | nindent 4 }}
  {{- end }}
{{- end }}
{{- with .Values.configmap.data | default (dict ) }}
data:
  {{- range $name, $contents := . }}
  {{- $name | nindent 2 }}: |-
    {{- $contents | toYaml | nindent 4 }}
  {{- end }}
{{- end }}
immutable: {{ .Values.configmap.immutable | default "false" }}
{{- end -}}
