# GuestBook

## Visit [images](https://github.com/MangalAnkur/Kubernetes_Guestbook/tree/master/Images) to view the outcome after deployments.
## Use [Wrapper script](https://github.com/MangalAnkur/Kubernetes_Guestbook) for configuration and deployment
## Install nginx ingress controller

Visit [configuration files](https://github.com/MangalAnkur/Kubernetes_Guestbook)  to download the configuration files
### Run the following commands

To see nodes

```bash
1. Kubectl get nodes
```
To create namespace nginx-ingress

```bash
2. kubectl apply -f nginx-ingress/ns-and-sa.yaml
```

To view the namespace 

```bash
3. kubectl get namaspace
```

```bash
4. kubectl apply -f nginx-ingress/default-server-secret.yaml
5. kubectl apply -f nginx-ingress/nginx-config.yaml
6. kubectl apply -f nginx-ingress/rbac.yaml
7. kubectl apply -f nginx-ingress/nginx-ingress.yaml
8. kubectl apply -f nginx-ingress/nginx-ingress-daemon-set.yaml
```

To see Running pods

```bash
9. kubectl get pods --namespace=nginx-ingress
```

Service with the Type NodePort

```bash
10. kubectl create -f nginx-ingress/nodeport.yaml
```

Service with the LoadBalancer

```bash
11. kubectl apply -f nginx-ingress/loadbalancer.yaml
```

To see services

```bash
12. kubectl get svc nginx-ingress --namespace=nginx-ingress
```

Port forward to your localmachine

```bash
13. pod_name=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' --namespace=nginx-ingress)
14. kubectl port-forward $pod_name 8080:8080 --namespace=nginx-ingress
```

To see details of nginx-ingress namspace

```bash
15. kubectl describe svc nginx-ingress --namespace=nginx-ingress
```


##  ########################################################################

## Now for guest book on Stage

Visit [configuration files](https://github.com/MangalAnkur/Kubernetes_Guestbook)  to download the configuration files

### Run the following commands

To create namespace Stage

```bash
1. kubectl create namespace staging
```

To view namespace

```bash
2. kubectl get namespace
```

To store data of guestbook using Redis

```bash
3. kubectl create -f redis-master-deployment.yaml  --namespace=staging
```

Create service to communicate with the redis master 

```bash
4. kubectl create -f redis-master-service.yaml --namespace=staging
```

Now Redis client and it's service

```bash
5. kubectl create -f redis-slave-deployment.yaml  --namespace=staging
6. kubectl create -f redis-slave-service.yaml  --namespace=staging
```

Now create Frontend for GuestBook 

```bash
7. kubectl create -f frontend-deployment.yaml --namespace=staging
```

Service To communicate by Frontend 

```bash
8. kubectl create -f frontend-service.yaml --namespace=staging
```

To see Service

```bash
9. kubect get svc --namespace=staging
```
### It will give an externel ip, Use that ip for communicating with guestbook application


## ############################################################################

## Now for guest book on Production

Visit [configuration files](https://github.com/MangalAnkur/Kubernetes_Guestbook)  to download the configuration files

### Run the following commands

To create namespace Production

```bash
1. kubectl create namespace production
```

To view namespace

```bash
2. kubectl get namespace
```

To store data of guestbook using Redis

```bash
3. kubectl create -f redis-master-deployment.yaml  --namespace=production
```

Create service to communicate with the redis master

```bash
4. kubectl create -f redis-master-service.yaml --namespace=production
```

Now Redis client and it's service

```bash
5. kubectl create -f redis-slave-deployment.yaml  --namespace=production
6. kubectl create -f redis-slave-service.yaml  --namespace=production
```

Now create Frontend for GuestBook

```bash
7. kubectl create -f frontend-deployment.yaml --namespace=production
```

Service To communicate by Frontend

```bash
8. kubectl create -f frontend-service.yaml --namespace=production
```

To see Service

```bash
9. kubectl get svc --namespace=production 
```
### It will give an externel ip, Use that ip for communicating with guestbook application



## Auto scaling on productuion and Stage

Visit [configuration files](https://github.com/MangalAnkur/Kubernetes_Guestbook)  to download the configuration files

Run the following commands

```bash
1. kubectl apply -f redis-master-pod-utilization.yaml --namespace=staging
2. kubectl apply -f redis-master-slave-utilization.yaml --namespace=staging
3. kubectl apply -f redis-slave-pod-utilization.yaml --namespace=staging
4. kubectl apply -f redis-master-pod-utilization.yaml --namespace=production
5. kubectl apply -f redis-master-slave-utilization.yaml --namespace=production
6. kubectl apply -f redis-slave-pod-utilization.yaml --namespace=production
```
Or without using yaml files

```bash
To see Deployments
1. kubectl get deployment  --namespace=production
2. kubectl autoscale deployment <deployment name> --min=3 --max=15 --cpu-percent=75  --namespace=production

3.  kubectl get deployment  --namespace=staging
4. kubectl autoscale deployment <deployment name> --min=3 --max=15 --cpu-percent=75  --namespace=staging
```

## ########################################################################


