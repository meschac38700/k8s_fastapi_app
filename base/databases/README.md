#### Zalando postgresql operator
```bash
helm install postgres-operator --namespace staging --create-namespace postgres-operator-charts/postgres-operator
```

#### Run postgresql operator UI (Optional)
```bash
helm install postgres-operator-ui --namespace staging postgres-operator-ui-charts/postgres-operator-ui
```

#### Run kustomization
```bash
 kubectl apply -k deploy/staging
```

> [!WARNING] 
> (Optional) since we are binding the operator generated secret with credentials in our api pod.
> 
> Do not forget to update the database password secret
> Take it from `fastapi.stg-api-database.credentials.postgresql.acid.zalan.do` secret then copy it to `stg-api-secret-XXXXX` 
> And finally delete the pod or rollout the deployment (delete pod it's recommended)


#### Cloud native postgresql operator

```bash
helm repo add cnpg https://cloudnative-pg.github.io/charts
```
```bash
helm upgrade --install api-database --namespace staging --create-namespace cnpg/cloudnative-pg
```
