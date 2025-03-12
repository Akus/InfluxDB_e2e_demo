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
kubectl create namespace ingress-nginx

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

# create nginx ingress controller
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install my-ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx

cd ../../k8s_manifests
kubectl apply -f ingress-resources.yaml
kubectl apply -f argocd-ingress.yaml -n argocd
kubectl apply -f mosquitto-ingress.yaml -n mosquitto
kubectl apply -f influxdb-ingress.yaml -n influxdb

# get LB DNS for Route53
kubectl get service --namespace ingress-nginx my-ingress-nginx-controller --output wide --watch
kubectl --namespace ingress-nginx get services -o wide -w my-ingress-nginx-controller