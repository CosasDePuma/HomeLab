---
{{- /* -------------- Deployment ------------- */ -}}
{{- define "deployment.base.tpl" -}}
apiVersion: "apps/v1"
kind: "Deployment"
metadata:
  name: {{ include "name" . | quote }}
  labels:
    {{- include "labels" . | nindent 4 }}
  annotations:
    {{- include "annotations" . | nindent 4 }}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: {{ include "name" . | quote }}
  template:
    metadata:
      labels:
        {{- include "labels" . | nindent 8 }}
      annotations:
        {{- include "annotations" . | nindent 8 }}
    spec:
      containers:
      - name: {{ include "name" . | quote }}
        imagePullPolicy: "IfNotPresent"
        resources:
          requests:
            cpu: "0m"
            memory: "0Mi"
          limits:
            cpu: "10m"
            memory: "128Mi"
{{- end -}}

{{- define "deployment.tpl" -}}
{{- /* -- Checking types -- */ -}}
{{- if ne 2 (len .) -}}{{- printf "[deployment.tpl] Argument should be a list with only two values (curr: %d)" (len .) | fail -}}{{- end -}}
{{- $values := first . -}}{{- $overlay := last . -}}
{{- if not (kindIs "map" $values) -}}{{- printf ("[deployment.tpl] First item must be a `map` (%s)") (toString $values) | fail -}}{{- end -}}
{{- if not (kindIs "string" $overlay) -}}{{- printf ("[deployment.tpl] Second item must be a `string` (%s)") (toString $overlay) | fail -}}{{- end -}}
{{- /* -- Merge & Return -- */ -}}
{{- $base := include "deployment.base.tpl" $values | fromYaml -}}{{- $over := include $overlay $values | fromYaml -}}
{{- include "merge.deep" (list $over $base) | nindent 0 -}}
{{- end -}}
...
