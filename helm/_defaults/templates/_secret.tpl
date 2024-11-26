---
{{- /* -------------- Secret ------------- */ -}}
{{- define "secret.base.tpl" -}}
apiVersion: "v1"
kind: "Secret"
metadata:
  name: {{ include "name" . | quote}}
  labels:
    {{- include "labels" . | nindent 4 }}
  annotations:
    {{- include "annotations" . | nindent 4 }}
data: {}
type: "Opaque"
{{- end -}}

{{- define "secret.tpl" -}}
{{- /* -- Checking types -- */ -}}
{{- if ne 2 (len .) -}}{{- printf "[secret.tpl] Argument should be a list with only two values (curr: %d)" (len .) | fail -}}{{- end -}}
{{- $values := first . -}}{{- $overlay := last . -}}
{{- if not (kindIs "map" $values) -}}{{- printf ("[secret.tpl] First item must be a `map` (%s)") (toString $values) | fail -}}{{- end -}}
{{- if not (kindIs "string" $overlay) -}}{{- printf ("[secret.tpl] Second item must be a `string` (%s)") (toString $overlay) | fail -}}{{- end -}}
{{- /* -- Merge & Return -- */ -}}
{{- $base := include "secret.base.tpl" $values | fromYaml -}}{{- $over := include $overlay $values | fromYaml -}}
{{- include "merge.deep" (list $over $base) | nindent 0 -}}
{{- end -}}
...
