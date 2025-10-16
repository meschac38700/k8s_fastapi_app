#!/bin/sh

# prepare postgresql operator (cloud native pg)
helm upgrade --install api-database --namespace staging --create-namespace cnpg/cloudnative-pg

# deploy using fluxCD
flux bootstrap github --token-auth -n flux-system-stg --owner=$GITHUB_USER --repository=k8s_fastapi_getstarted --branch=master --path=./deploy/staging --personal --components source-controller,kustomize-controller,helm-controller,notification-controller --components-extra image-reflector-controller,image-automation-controller

# run fluxCD tools for image update automation
kubectl apply -k deploy/staging/monitoring
