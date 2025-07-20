# grafana, prometheus on minikube with helm
# https://medium.com/@netopschic/deploying-kube-state-metric-prometheus-and-grafana-for-minikube-cluster-using-helm-513d6072ac55

kubectl config get-contexts
kubectl create namespace monitoring

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/prometheus `
  --namespace monitoring `
  --set server.service.type=NodePort
  
kubectl get pods -n monitoring

kubectl port-forward svc/prometheus-server -n monitoring 9090:80

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm install grafana grafana/grafana `
  --namespace monitoring `
  --set service.type=NodePort
  
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | ForEach-Object { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }

kubectl port-forward svc/grafana -n monitoring 3000:80

helm install kube-state-metrics prometheus-community/kube-state-metrics `
  --namespace monitoring
  
#  Add http://prometheus-server.monitoring.svc.cluster.local as the prometheus url.

#  After saving the dashboard, Navigate to “Dashboard” and import a pre-configured dashboard using ID 6417.

helm search repo bitnami
helm repo update
helm install bitnami/mysql --generate-name
helm list

helm status mysql-1612624192
helm uninstall mysql-1612624192
helm upgrade <release> <chart>                            # Upgrade a release
helm upgrade <release> <chart> --atomic                   # If set, upgrade process rolls back changes made in case of failed upgrade.
helm upgrade <release> <chart> --dependency-update        # update dependencies if they are missing before installing the chart
helm upgrade <release> <chart> --version <version_number> # specify a version constraint for the chart version to use
helm upgrade <release> <chart> --values                   # specify values in a YAML file or a URL (can specify multiple)
helm upgrade <release> <chart> --set key1=val1,key2=val2  # Set values on the command line (can specify multiple or separate valuese)
helm upgrade <release> <chart> --force                    # Force resource updates through a replacement strategy
helm rollback <release> <revision>                        # Roll back a release to a specific revision
helm rollback <release> <revision>  --cleanup-on-fail     # Allow deletion of new resources created in this rollback when rollback fails