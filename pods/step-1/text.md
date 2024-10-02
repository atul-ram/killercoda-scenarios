### Create a namespace called `cygnus` and create a pod with name `alpha` and image `nginx` in this namespace.

```
kubectl create namespace cygnus
```{{exec}}

```
kubectl run alpha --image=nginx --restart=Never -n cygnus
```{{exec}}

