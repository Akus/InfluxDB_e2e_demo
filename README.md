### InfluxDB e2e demo setup

## Terraform infra
terraform-infra/
│── modules/                 # Reusable Terraform modules
│   ├── networking/          # VPC, subnets, security groups, etc.
│   ├── compute/             # EC2, ECS, EKS, etc.
│   ├── storage/             # S3, RDS, EFS, etc.
│   ├── monitoring/          # CloudWatch, Prometheus, etc.
│── envs/                    # Environment-specific configurations
│   ├── development/         
│   │   ├── main.tf          # Calls modules with dev-specific variables
│   │   ├── variables.tf     # Defines environment-specific variables
│   │   ├── backend.tf       # Remote state configuration
│   │   ├── outputs.tf       # Outputs for reference
│   ├── staging/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── backend.tf
│   │   ├── outputs.tf
│   ├── production/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── backend.tf
│   │   ├── outputs.tf
│── global/                  # Shared configurations across all environments
│   ├── providers.tf         # Provider configurations (AWS, GCP, etc.)
│   ├── versions.tf          # Terraform version constraints
│── terraform.tfvars         # Global variables (optional)
│── README.md                # Documentation


## Terraform setup

### Create folder structure
terraform-infra\scripts\setup_terraform_folder_structure.ps1

### Download and install Terraform version
https://releases.hashicorp.com/terraform/1.6.0/

### Create S3 bucket for Terraform state files
akos-influx-eks-terraform-state-bucket

### Create DynamoDB table for Terraform state lock
table name: terraform-lock
partition key: LockID

### deploy networking module into the development environment
cd "E:\Documents\repos\InfluxDB_e2e_demo\terraform-infra\envs\development"
terraform init
terraform plan -out=tfplan
terraform apply "tfplan"

## Investigating dependency cycles

```powershell
terraform graph | Out-File -Encoding ASCII graph.dot
dot -Tpng graph.dot -o graph.png
```

## EKS
``` bash

aws eks list-clusters
```

## ArgoCD
cd "modules/argocd"

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm search repo argo/argo-cd --versions

terraform plan -var="cluster-name=akos-influxdb-eks-development"
terraform apply -var="cluster-name=akos-influxdb-eks-development"

kubectl config get-contexts


# get context
aws eks update-kubeconfig --region eu-central-1 --name akos-influxdb-eks-development

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\"

# reach ArgoCD via HTTP instead of HTTPS
Check it in AWS Console/EKS/Services/argocd-server/LB DNS

http://ae7990a5e7b8f493cbd1c5fc724502e0-2061156755.eu-central-1.elb.amazonaws.com/login?return_url=http%3A%2F%2Fae7990a5e7b8f493cbd1c5fc724502e0-2061156755.eu-central-1.elb.amazonaws.com%2Fapplications

https://ae7990a5e7b8f493cbd1c5fc724502e0-2061156755.eu-central-1.elb.amazonaws.com/login?return_url=http%3A%2F%2Fae7990a5e7b8f493cbd1c5fc724502e0-2061156755.eu-central-1.elb.amazonaws.com%2Fapplications

# decode ArgoCD password
$password = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}")))
Write-Host "ArgoCD admin password: $password"

kubectl get pods -n argocd
kubectl get svc -n argocd


## Cleanup environment
cd terraform-infra\modules\argocd
terraform destroy --auto-approve

cd terraform-infra\envs\development
terraform destroy --auto-approve

## Create environment
cd terraform-infra\envs\development
terraform apply --auto-approve

cd terraform-infra\modules\argocd
terraform apply -var="cluster_name=akos-influxdb-eks-development" --auto-approve

## Add Persistent Volume to EKS for InfluxDB

terraform plan -var="cluster_name=akos-influxdb-eks-development" -var="eks_node_group_security_group_id=sg-074c8ccdeb0a382ea" -var="vpc_private_subnets=subnet-07547ef6e8e74a57c"

terraform apply -var="cluster_name=akos-influxdb-eks-development" -var="eks_node_group_security_group_id=sg-074c8ccdeb0a382ea"  -var="vpc_private_subnets=subnet-07547ef6e8e74a57c"

kubectl get pv

kubectl get pvc -n influxdb
kubectl describe pvc -n influxdb influxdb-influxdb2

kubectl get pvc --all-namespaces

kubectl describe pv [pv-name]
kubectl describe pv efs-pv

kubectl describe pvc [pvc-name]
kubectl describe pvc efs-pvc

kubectl get storageclass
kubectl describe storageclass <storage-class-name>

## check InfluxDB after deploying it with ArgoCD with Git source (not Helm)
kubectl get all -n influxdb

helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver/
helm repo update
helm install aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver -n kube-system

kubectl get pods -n kube-system -l app=efs-csi-node
kubectl get pods -n kube-system -l app=efs-csi-controller

## RBAC

kubectl edit configmap aws-auth -n kube-system

  mapUsers: |
    - userarn: arn:aws:iam::823514127427:user/akos_bodor
      username: akos_bodor
      groups:
        - system:masters

## Startup steps
- deploy development
- set new context
aws eks update-kubeconfig --region eu-central-1 --name akos-influxdb-eks-development
- set RBAC for akos_bodor user
- install efs-csi-driver with helm
helm install aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver -n kube-system
- create namespace for environment
kubectl create namespace argocd
- install ArgoCD with helm
helm repo add argo https://argoproj.github.io/argo-helm
helm install argocd --namespace argocd argo/argo-cd --version 7.8.7
- get password for ArgoCD admin
$password = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}")))
Write-Host "ArgoCD admin password: $password"
- port forward ArgoCD
kubectl port-forward svc/argocd-server -n argocd 8080:443
- deploy InfluxDB with ArgoCD:
Repository URL (Git)
https://github.com/Akus/helm-charts.git
Revision (Tags)
influxdb2-2.1.2
Path
charts/influxdb2

- add storage class to influxdb values or use branch
storageClassName: "efs-sc"
- check InfluxDB pod

kubectl describe pod -n influxdb influxdb-influxdb2-0

kubectl get statefulset influxdb-influxdb2 -n influxdb -o yaml


kubectl port-forward svc/influxdb-influxdb2 -n influxdb 9090:80

$infl_password = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($(kubectl -n influxdb get secret influxdb-influxdb2-auth -o jsonpath="{.data.admin-password}")))
Write-Host "InfluxDB admin password: $infl_password"


## Create nginx ingress
https://medium.com/@muppedaanvesh/a-hands-on-guide-to-kubernetes-ingress-nginx-7c4c5b45eb89

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
kubectl create namespace ingress-nginx
helm install my-ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx

kubectl get service --namespace ingress-nginx my-ingress-nginx-controller --output wide --watch
kubectl --namespace ingress-nginx get services -o wide -w my-ingress-nginx-controller

# create ingress resource (mapping)
kubectl apply -f influxdb-ingress.yaml

# troubleshooting
kubectl get services -o wide -n ingress-nginx