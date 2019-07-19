#/bin/bash
echo "Attaching kubernetes cluster ..." 
gcloud container clusters get-credentials mstakx --zone us-central1-a --project earnest-mark-246509

echo "installing kubectl ..."
snap install kubectl --classic

echo "Instaling git ..."
apt install git 

echo "Cloning git repository ..."
git clone https://github.com/MangalAnkur/Kubernetes_Guestbook
cd Kubernetes_Guestbook

echo " Nginx-ingress controller deployment starting..."
echo "creating namespace ..."
kubectl apply -f nginx-ingress/ns-and-sa.yaml
kubectl apply -f nginx-ingress/default-server-secret.yaml

echo "Creating pod for nginx ingress controller ..."
kubectl apply -f nginx-ingress/nginx-config.yaml

echo "configuring rbac for storing data of nginx ingress controller ..." 
kubectl apply -f nginx-ingress/rbac.yaml
kubectl apply -f nginx-ingress/nginx-ingress.yaml 
kubectl apply -f nginx-ingress/nginx-ingress-daemon-set.yaml
kubectl create -f nginx-ingress/nodeport.yaml
kubectl apply -f nginx-ingress/loadbalancer.yaml
kubectl get svc nginx-ingress --namespace=nginx-ingress
kubectl describe svc nginx-ingress --namespace=nginx-ingress

echo "Pot forwarding ..."
pod_name=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' --namespace=nginx-ingress)
kubectl port-forward $pod_name 8080:8080 --namespace=nginx-ingress

#GuestBook on staging

echo "creating Namespace staging ..."
kubectl create namespace staging

echo "Deploying redis master ..."
kubectl create -f redis-master-deployment.yaml  --namespace=staging

echo "Deploying redis master service ..."
kubectl create -f redis-master-service.yaml --namespace=staging

echo "Deploying redis slave ..."
kubectl create -f redis-slave-deployment.yaml  --namespace=staging

echo "Deploying redis slave service ..."
kubectl create -f redis-slave-service.yaml  --namespace=staging

echo "Deploying frontend ..."
kubectl create -f frontend-deployment.yaml --namespace=staging

echo "Deploying frontend service ..."
kubectl create -f frontend-service.yaml --namespace=staging

echo "Configuring local DNS in hosts file by hostname staging-guestbook.mstakx.io ..."
echo "Visit staging-guestbook.mstakx.io"
external_ip=$(kubectl get services --namespace=staging  frontend --output jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "$external_ip staging-guestbook.mstakx.io "  >> /etc/hosts 
#Guestbook on production######################################################

echo "creating Namespace production ..."
kubectl create namespace production

echo "Deploying redis master ..."
kubectl create -f redis-master-deployment.yaml --namespace=production

echo "Deploying redis master service ..."
kubectl create -f redis-master-service.yaml --namespace=production

echo "Deploying redis slave ..."
kubectl create -f redis-slave-deployment.yaml --namespace=production

echo "Deploying redis slave service ..."
kubectl create -f redis-slave-service.yaml --namespace=production

echo "Deploying frontend ..."
kubectl create -f frontend-deployment.yaml  --namespace=production

echo "Deploying frontend service ..."
kubectl create -f frontend-service.yaml --namespace=production

echo "Configuring local DNS in hosts file by hostname guestbook.mstakx.io ..."
echo "Visit guestbook.mstakx.io"
external_ip=$(kubectl get services --namespace=production  frontend --output jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "$external_ip guestbook.mstakx.io "  >> /etc/hosts

#Auto scaling on productuion

echo "Autoscaling on redis-master of production ..."
kubectl apply -f redis-master-pod-utilization.yaml --namespace=production

echo "Autoscaling on redis-master-slave of production ..."
kubectl apply -f redis-master-slave-utilization.yaml --namespace=production

echo "Autoscaling on redis-slave of production ..."
kubectl apply -f redis-slave-pod-utilization.yaml --namespace=production

#Auto scaling on staging

echo "Autoscaling on redis-master of staging ..."
kubectl apply -f redis-master-pod-utilization.yaml --namespace=staging
ho "Autoscaling on redis-master-slave of staging ..."
kubectl apply -f redis-master-slave-utilization.yaml --namespace=staging

echo "Autoscaling on redis-slave of staging ..."
kubectl apply -f redis-slave-pod-utilization.yaml --namespace=staging







