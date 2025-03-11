cd ../terraform-infra/envs/development
terraform init
terraform plan
terraform apply -auto-approve

# set RBAC

aws eks update-kubeconfig --region eu-central-1 --name akos-influxdb-eks-development

helm install aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver -n kube-system

kubectl create namespace argocd
kubectl create namespace influxdb
kubectl create namespace mosquitto
kubectl create namespace grafana
kubectl create namespace prometheus
kubectl create namespace nginx-ingress

cd ../../../helm-charts/argo-cd
helm install argocd . -n argocd

cd ../mosquitto
kubectl create secret generic mosquitto-certs --from-file="..\..\letsencrypt\live\" -n mosquitto
helm install mosquitto . -n mosquitto

cd ../influxdb2
helm install influxdb . -n influxdb

# cd ../grafana
# helm install grafana . -n grafana

# cd ../prometheus
# helm install prometheus . -n prometheus

cd ../../k8s_manifests
kubectl apply -f nginx-ingress.yaml -n nginx-ingress