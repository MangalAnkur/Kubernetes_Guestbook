#/bin/bash
gcloud container clusters get-credentials mstakx --zone us-central1-a --project earnest-mark-246509
snap install kubectl --classic
apt install git 
git clone https://github.com/ankur.mangal/ankur_kubernetes_beginer

kubectl apply -f nginx-ingress/ns-and-sa.yaml
kubectl apply -f nginx-ingress/default-server-secret.yaml
kubectl apply -f nginx-ingress/nginx-config.yaml
kubectl apply -f nginx-ingress/rbac.yaml
kubectl apply -f nginx-ingress/nginx-ingress.yaml
kubectl apply -f nginx-ingress/nginx-ingress-daemon-set.yaml
kubectl get pods --namespace=nginx-ingress
kubectl create -f nginx-ingress/nodeport.yaml
kubectl apply -f nginx-ingress/loadbalancer.yaml
kubectl get svc nginx-ingress --namespace=nginx-ingress
kubectl describe svc nginx-ingress --namespace=nginx-ingress
kubectl port-forward <nginx-ingress-pod> 8080:8080 --namespace=nginx-ingress

#GuestBook on staging
kubectl create namespace staging
kubectl create -f redis-master-deployment.yaml  --namespace=staging
kubectl create -f redis-master-service.yaml --namespace=staging
kubectl create -f redis-slave-deployment.yaml  --namespace=staging
kubectl create -f redis-slave-service.yaml  --namespace=staging
kubectl create -f frontend-deployment.yaml --namespace=staging
kubectl create -f frontend-service.yaml --namespace=staging


#Guestbook on production
kubectl create namespace production
kubectl create -f redis-master-deployment.yaml --namespace=production
kubectl create -f redis-master-service.yaml --namespace=production
kubectl create -f redis-slave-deployment.yaml --namespace=production
kubectl create -f redis-slave-service.yaml --namespace=production
kubectl create -f frontend-deployment.yaml  --namespace=production
kubectl create -f frontend-service.yaml --namespace=production


#Auto scaling on productuion
kubectl apply -f redis-master-pod-utilization.yaml --namespace=production
kubectl apply -f redis-master-slave-utilization.yaml --namespace=production
kubectl apply -f redis-slave-pod-utilization.yaml --namespace=production

#Auto scaling on staging
kubectl apply -f redis-master-pod-utilization.yaml --namespace=staging
kubectl apply -f redis-master-slave-utilization.yaml --namespace=staging
kubectl apply -f redis-slave-pod-utilization.yaml --namespace=staging







