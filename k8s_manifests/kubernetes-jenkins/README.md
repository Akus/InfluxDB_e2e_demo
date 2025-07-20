# Kubernetes Manifests for Jenkins Deployment

Refer https://devopscube.com/setup-jenkins-on-kubernetes-cluster/ for step by step process to use these manifests.

kubectl create namespace devops-tools

kubectl apply -f serviceAccount.yaml

Important Note: Replace 'worker-node01' with any one of your cluster worker nodes hostname.

You can get the worker node hostname using the kubectl.

kubectl get nodes
kubectl create -f volume.yaml

kubectl get pvc -n devops-tools
kubectl get pv -n devops-tools

kubectl apply -f deployment.yaml
kubectl get deployments -n devops-tools
kubectl describe deployments --namespace=devops-tools

# port forward:
kubectl -n jenkins port-forward <pod_name> 8080:8080
kubectl port-forward jenkins-6846f7864d-w68vh 8080:8080 -n devops-tools

# AWS ALB ingress:
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"
eksctl utils associate-iam-oidc-provider --region <region> --cluster <cluster-name> --approve
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.0/docs/install/iam_policy.json
aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam-policy.json

eksctl create iamserviceaccount \
  --cluster <cluster-name> \
  --namespace kube-system \
  --name aws-load-balancer-controller \
  --attach-policy-arn arn:aws:iam::<account-id>:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve

helm repo add eks https://aws.github.io/eks-charts
helm repo update

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=<cluster-name> \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=<region>

kubectl get deployment -n kube-system aws-load-balancer-controller  

kubectl apply -f jenkins-alb-ingress.yaml -n devops-tools