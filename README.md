# k8s_fastapi_getstarted
Kubernetes repository to manage fastapi getstarted project deployment

[Project repo](https://github.com/meschac38700/fastapi_getstarted)


### Quick start
```bash
sh prod.sh
```
```bash
sh staging.sh
```

#### Run ArgoCD
```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
#### Run application
```bash
kubectl apply -f application.yaml
```

#### Run FluxCD
Follow the tutorial [here](https://fluxcd.io/flux/get-started/)
##### Staging deploy

```bash
flux bootstrap github --token-auth -n flux-system-stg --owner=$GITHUB_USER --repository=k8s_fastapi_getstarted --branch=master --path=./deploy/staging --personal --components source-controller,kustomize-controller,helm-controller,notification-controller --components-extra image-reflector-controller,image-automation-controller
```

##### Prod deploy

```bash
flux bootstrap github --token-auth -n flux-system-prod --owner=$GITHUB_USER --repository=k8s_fastapi_getstarted --branch=master --path=./deploy/prod --personal --components source-controller,kustomize-controller,helm-controller,notification-controller --components-extra image-reflector-controller,image-automation-controller
```


#### Image registry scanner

Then we need to apply image update automation manifest files.
```bash
kubectl apply -k deploy/{staging|prod}/automation/
```

[Image Scanner link](https://fluxcd.io/flux/guides/image-update/#configure-image-scanning)   
Create a registry secret in the same namespace as the `ImageRegistryRepository` named `fastapi-getstarted-docker-registry`

[Image policy semver](https://fluxcd.io/flux/guides/image-update/#imagepolicy-examples)

###### Quick CLI to generate docker secret for ImageRegistryRepository
```bash
kubectl create secret docker-registry [name_of_secret] \
  --docker-username=[username] \
  --docker-password=[password_or_token] \
  --dry-run=client -o yaml > deploy/registry-secret.yaml
```

```yaml
apiVersion: image.toolkit.fluxcd.io/v1beta2
kind: ImageRepository
metadata:
  name: podinfo
  namespace: default
spec:
  image: stefanprodan/podinfo
  interval: 1h
  secretRef:
    name: regcred

---

apiVersion: v1
kind: Secret
metadata:
  name: regcred
  namespace: default
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: XXXXXXXXX
```
