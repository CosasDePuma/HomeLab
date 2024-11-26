---
{{- /* -------------- IngressRouteTCP ------------- */ -}}
{{- define "ingressroutetcp.base.tpl" -}}
apiVersion: "traefik.io/v1alpha1"
kind: "IngressRouteTCP"
metadata:
  name: {{ include "name" . | quote }}
  namespace: {{ .Values.namespace | default .Release.Namespace | quote }}
  labels:
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
  entryPoints: ["tcp"]
  routes:
    - match: "HostSNI(`*`)"
      services:
        name: {{ include "name" . | quote }}
        port: {{ include "svcName" . | quote }}
{{- end -}}

{{- define "ingressroutetcp.tpl" -}}
{{- /* -- Checking types -- */ -}}
{{- if ne 2 (len .) -}}{{- printf "[ingressroutetcp.tpl] Argument should be a list with only two values (curr: %d)" (len .) | fail -}}{{- end -}}
{{- $values := first . -}}{{- $overlay := last . -}}
{{- if not (kindIs "map" $values) -}}{{- printf ("[ingressroutetcp.tpl] First item must be a `map` (%s)") (toString $values) | fail -}}{{- end -}}
{{- if not (kindIs "string" $overlay) -}}{{- printf ("[ingressroutetcp.tpl] Second item must be a `string` (%s)") (toString $overlay) | fail -}}{{- end -}}
{{- /* -- Merge & Return -- */ -}}
{{- $base := include "ingressroutetcp.base.tpl" $values | fromYaml -}}{{- $over := include $overlay $values | fromYaml -}}
{{- include "merge.deep" (list $over $base) | nindent 0 -}}
{{- end -}}
---
{{- /* -------------- IngressRouteUDP ------------- */ -}}
{{- define "ingressrouteudp.base.tpl" -}}
kind: "IngressRouteUDP"
spec:
  entryPoints: ["udp"]
{{- end -}}

{{- define "ingressrouteudp.tpl" -}}
{{- /* -- Checking types -- */ -}}
{{- if ne 2 (len .) -}}{{- printf "[ingressrouteudp.tpl] Argument should be a list with only two values (curr: %d)" (len .) | fail -}}{{- end -}}
{{- $values := first . -}}{{- $overlay := last . -}}
{{- if not (kindIs "map" $values) -}}{{- printf ("[ingressrouteudp.tpl] First item must be a `map` (%s)") (toString $values) | fail -}}{{- end -}}
{{- if not (kindIs "string" $overlay) -}}{{- printf ("[ingressrouteudp.tpl] Second item must be a `string` (%s)") (toString $overlay) | fail -}}{{- end -}}
{{- /* -- Merge & Return -- */ -}}
{{- $ctx := set $values "ingressroutetcp" ($values.ingressrouteudp | default dict) -}}
{{- $udptpl := include "ingressroutetcp.tpl" (list $ctx "ingressrouteudp.base.tpl") -}}
{{- $base := $udptpl | fromYaml -}}{{- $over := include $overlay $values | fromYaml -}}
{{- include "merge.deep" (list $over $base) | nindent 0 -}}
{{- end -}}
---
{{- /* -------------- IngressRoute ------------- */ -}}
{{- define "ingressroute.base.tpl" -}}
kind: "IngressRoute"
spec:
  entryPoints: ["websecure"]
  routes:
    - kind: "Rule"
      match: "Host(`*`) && PathPrefix(`/`)"
{{- end -}}

{{- define "ingressroute.tpl" -}}
{{- /* -- Checking types -- */ -}}
{{- if ne 2 (len .) -}}{{- printf "[ingressroute.tpl] Argument should be a list with only two values (curr: %d)" (len .) | fail -}}{{- end -}}
{{- $values := first . -}}{{- $overlay := last . -}}
{{- if not (kindIs "map" $values) -}}{{- printf ("[ingressroute.tpl] First item must be a `map` (%s)") (toString $values) | fail -}}{{- end -}}
{{- if not (kindIs "string" $overlay) -}}{{- printf ("[ingressroute.tpl] Second item must be a `string` (%s)") (toString $overlay) | fail -}}{{- end -}}
{{- /* -- Merge & Return -- */ -}}
{{- $ctx := set $values "ingressroutetcp" ($values.ingressroute | default dict) -}}
{{- $tpl := include "ingressroutetcp.tpl" (list $ctx "ingressroute.base.tpl") -}}
{{- $base := $tpl | fromYaml -}}{{- $over := include $overlay $values | fromYaml -}}
{{- include "merge.deep" (list $over $base) | nindent 0 -}}
{{- end -}}
...
