{{- define "secret.tpl" -}}
---
apiVersion: v1
kind: Secret
metadata:
  name: "{{ include "name" . }}"
  labels:
    {{- include "labels" . | nindent 4 }}
    {{- with .Values.secret.labels | default (dict ) }}
    {{- . | toYaml | nindent 4 }}
    {{- end }}
  annotations:
    {{- include "annotations" . | nindent 4 }}
    {{- with .Values.secret.annotations }}
    {{- . | toYaml | nindent 4 }}
    {{- end }}
{{- with .Values.secret.data }}
data:
  {{- range $key, $value := . }}
  {{- $key | nindent 2 }}:  {{ $value | b64enc | quote }}
  {{- end }}
{{- end }}
type: {{ .Values.secret.type | default "Opaque" }}
{{- end -}}
