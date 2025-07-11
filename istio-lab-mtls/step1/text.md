



#### check status

```bash
kubectl get pods -n istio-system
```{{exec}}


#### deploy applicaiton

```bash
kubectl apply -f https://raw.githubusercontent.com/Azure-Samples/aks-store-demo/refs/heads/main/aks-store-quickstart.yaml
```{{exec}}


First, deploy a test pod outside the mesh, in the default namespace, to simulate an external client:

```bash

kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: curl-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: curl
  template:
    metadata:
      labels:
        app: curl
    spec:
      containers:
      - name: curl
        image: docker.io/curlimages/curl
        command: ["sleep", "3600"]
EOF

```{{exec}}

Once the pod is running, try sending a request to the store-front service:

Run the following command to get the name of the test pod.

```bash
CURL_POD_NAME="$(kubectl get pod -l app=curl -o jsonpath="{.items[0].metadata.name}")"
kubectl exec -it ${CURL_POD_NAME} -- curl -IL store-front.default.svc.cluster.local:80
```{{exec}}

Now, enforce strict mTLS for all services in the namespace:

```bash
kubectl apply  -f - <<EOF
apiVersion: security.istio.io/v1
kind: PeerAuthentication
metadata:
  name: pets-mtls
  namespace: default
spec:
  mtls:
    mode: STRICT
EOF
```{{exec}}


```bash

kubectl exec -it ${CURL_POD_NAME} -- curl -IL store-front.default.svc.cluster.local:80
```{{exec}}

This time, the request fails because the store-front service now rejects plaintext connections.

To verify that services inside the mesh can still communicate, deploy a test pod inside the namespace:

```bash
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: curl-inside
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: curl
  template:
    metadata:
      labels:
        app: curl
    spec:
      containers:
      - name: curl
        image: curlimages/curl
        command: ["sleep", "3600"]
EOF
```{{exec}}

Once it’s running, get its name:

``` 
CURL_INSIDE_POD="$(kubectl get pod -n pets -l app=curl -o jsonpath="{.items[0].metadata.name}")"
```{{exec}}

Then, try the request again:

```
kubectl exec -it ${CURL_INSIDE_POD} -n pets -- curl -IL store-front.pets.svc.cluster.local:80

```{{exec}}