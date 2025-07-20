# cert-manager setup and TLS demo
https://cert-manager.io/docs/tutorials/acme/nginx-ingress/

# how to install cert-manager with helm
https://cert-manager.io/docs/installation/helm/

```bash
kubectl apply -f kuard-all-in-one.yaml
kubectl get ingress

helm repo add jetstack https://charts.jetstack.io --force-update
helm install `
  cert-manager jetstack/cert-manager `
  --namespace cert-manager `
  --create-namespace `
  --version v1.17.0 `
  --set crds.enabled=true

kubectl apply -f letsencrypt-staging-issuer.yaml
kubectl apply -f letsencrypt-prod-issuer.yaml

kubectl describe issuer letsencrypt-staging

# the below line is uncommented in the standalone ingress yaml:
# cert-manager.io/issuer: "letsencrypt-staging"

kubectl apply -f kuard-ingress-staging.yaml

kubectl get certificate
kubectl describe certificate quickstart-example-tls
kubectl describe secret quickstart-example-tls

# if everything is fine then letsencrypt prod can be used:
kubectl apply -f kuard-ingress-prod.yaml
kubectl delete secret quickstart-example-tls
kubectl describe certificate quickstart-example-tls
kubectl describe order quickstart-example-tls-889745041

kubectl get order
kubectl describe order quickstart-example-tls-2-316881926

# check challenge status (if the order is completed this will be empty)
kubectl describe challenge quickstart-example-tls-2-316881926-2132225753

kubectl describe certificate quickstart-example-tls

```