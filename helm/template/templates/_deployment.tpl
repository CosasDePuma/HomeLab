{{- define "deployment.tpl" -}}
{{- $values := .Values.deployment | default (dict ) -}}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: "{{ include "name" . }}"
  labels:
    {{- include "labels" . | nindent 4 }}
    {{- with $values.labels | default (dict ) }}
    {{- . | toYaml | nindent 4 }}
    {{- end }}
  annotations:
    {{- include "annotations" . | nindent 4 }}
    {{- with $values.annotations }}
    {{- . | toYaml | nindent 4 }}
    {{- end }}
spec:
  replicas: {{ $values.replicas | default 1 }}
  selector:
    matchLabels:
      app: {{ include "name" . }}
  template:
    metadata:
      labels:
        {{- include "labels" . | nindent 8 }}
        {{- with $values.labels | default (dict ) }}
        {{- . | toYaml | nindent 8 }}
        {{- end }}
      annotations:
        {{- include "annotations" . | nindent 8 }}
        {{- with $values.annotations }}
        {{- . | toYaml | nindent 8 }}
        {{- end }}
    spec:
      {{- if $values.spec.template.spec.containers -}}
      containers:
        {{- range $container := $values.spec.template.spec.containers }}
        - name: {{ $container.name | default (include "name" $) | quote }}
          image: "{{ $container.image.repository }}:{{ $container.image.tag | default "latest" }}"
          imagePullPolicy: {{ $container.pullPolicy | default "IfNotPresent" | quote }}
          {{- with $container.env }}
          env:
            {{- . | toYaml | nindent 12 }}
          {{- end }}
          {{- with $container.envFrom }}
          envFrom:
            {{- . | toYaml | nindent 12 }}
          {{- end }}
          {{- with $container.ports }}
          ports:
            {{- range $port := . }}
            - containerPort: {{ $port.port }}
              protocol: {{ $port.protocol | default "TCP" | quote }}
              {{- with $port.name }}
              name: {{ . | quote }}
              {{- end }}
            {{- end }}
          {{- end }}
          {{- with $container.resources -}}
          resources:
            {{- with .requests -}}
            requests:
              cpu: {{ .cpu | default "50m" | quote }}
              memory: {{ .memory | default "64Mi" | quote }}
            {{- end -}}
            {{- with .limits -}}
            limits:
              cpu: {{ .cpu | default "100m" | quote }}
              memory: {{ .memory | default "128Mi" | quote }}
            {{- end -}}
          {{- end -}}
          volumeMounts:
            {{- with $container.volumeMounts }}
            {{- range $mount := . }}
            - name: {{ $mount.name }}
              mountPath: {{ $mount.mountPath }}
              {{- if $mount.subPath }}
              subPath: {{ $mount.subPath }}
              {{- end }}
              readOnly: {{ $mount.readOnly | default false }}
            {{- end }}
            {{- end }}
          {{- end }}
        {{- end }}
      volumes:
        {{- with $values.volumes }}
        {{- range $volume := . }}
        - name: {{ $volume.name }}
          {{- with $volume.secret }}
          secret:
            secretName: {{ $volume.secret }}
          {{- end }}
          {{- with $volume.configmap }}
          configmap:
            name: {{ $volume.configmap }}
          {{- end }}
        {{- end }}
        {{- end }}
{{- end -}}
