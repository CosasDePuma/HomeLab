---
{{- /* -------------- PersistentVolumeClaim ------------- */ -}}
{{- define "persistentvolumeclaim.base.tpl" -}}
apiVersion: "v1"
kind: "PersistentVolumeClaim"
metadata:
  name: {{ include "name" . | quote }}
  namespace: {{ .Values.namespace | default .Release.Namespace | quote }}
  labels:
    type: nfs
    {{- include "labels" . | nindent 4 }}
    {{- with .Values.labels }}
    {{- . | toYaml | nindent 4 }}
    {{- end }}
  annotations:
    {{- include "annotations" . | nindent 4 }}
    {{- with .Values.annotations }}
    {{- . | toYaml | nindent 4 }}
    {{- end }}
spec:
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: "1Gi"
  selector:
    matchLabels: {}
{{- end -}}

{{- define "persistentvolumeclaim.tpl" -}}
{{- /* -- Checking types -- */ -}}
{{- if ne 2 (len .) -}}{{- printf "[persistentvolumeclaim.tpl] Argument should be a list with only two values (curr: %d)" (len .) | fail -}}{{- end -}}
{{- $values := first . -}}{{- $overlay := last . -}}
{{- if not (kindIs "map" $values) -}}{{- printf ("[persistentvolumeclaim.tpl] First item must be a `map` (%s)") (toString $values) | fail -}}{{- end -}}
{{- if not (kindIs "string" $overlay) -}}{{- printf ("[persistentvolumeclaim.tpl] Second item must be a `string` (%s)") (toString $overlay) | fail -}}{{- end -}}
{{- /* -- Merge & Return -- */ -}}
{{- $base := include "persistentvolumeclaim.base.tpl" $values | fromYaml -}}{{- $over := include $overlay $values | fromYaml -}}
{{- include "merge.deep" (list $over $base) | nindent 0 -}}
{{- end -}}
...
