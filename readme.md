# GuestBook

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
13. kubectl port-forward <nginx-ingress-pod> 8080:8080 --namespace=nginx-ingress
```
To see details of nginx-ingress namspace

```bash
14. kubectl describe svc nginx-ingress --namespace=nginx-ingress
```




## Now for guest book 




