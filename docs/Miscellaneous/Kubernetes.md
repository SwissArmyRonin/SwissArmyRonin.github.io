# Kubernetes

## Helm

List all installed Helm charts in a Kubernetes cluster:

```shell
helm list --kube-context dev -A
```

Inspect a Helm chart:

```shell
helm template bootstrap-snowflake app-base-charts/bootstrap-snowflake \
  -f app-values/values.yaml \
  -f app-values/dev/values.yaml \
  -f app-values/dev/eu-north-1/values.yaml \
  -f app-values/dev/eu-north-1/bootstrap-snowflake/values.yaml \
  -f app-versions/dev/eu-north-1/bootstrap-snowflake/version.yaml \
  --namespace development 
```

Install or upgrade a Helm chart with multiple values files:

```shell
helm upgrade --install bootstrap-snowflake app-base-charts/bootstrap-snowflake \
   -f app-values/values.yaml \
   -f app-values/dev/values.yaml \
   -f app-values/dev/eu-north-1/values.yaml \
   -f app-values/dev/eu-north-1/bootstrap-snowflake/values.yaml \
   -f app-versions/dev/eu-north-1/bootstrap-snowflake/version.yaml \
   --namespace development \
   --kube-context dev
```

Uninstall a Helm chart:

```shell
helm uninstall bootstrap-snowflake --namespace development --kube-context dev
```

## ArgoCD

Reload an appset in ArgoCD:

```shell
kubectl --context dev-eu-north-1 -n argocd apply -f argocd-app-files/dev/eu-north-1/appsets/bootstrap-snowflake-appset.yaml
```

## Use a shared OAuth2 proxy for multiple ingresses

<https://www.callumpember.com/Kubernetes-A-Single-OAuth2-Proxy-For-Multiple-Ingresses/>



