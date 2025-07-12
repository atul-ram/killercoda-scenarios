```bash
kubectl exec -it tester -- \
    bash -c 'for i in {1..2}; \
                do curl -s -X POST http://store-front.default.svc.cluster.local; \
                echo; \
            done;'

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

Once it’s running, get its name

``` 
CURL_INSIDE_POD="$(kubectl get pod -l app=curl -o jsonpath="{.items[0].metadata.name}")"
```{{exec}}

Then, try the request again:

```
kubectl exec -it ${CURL_INSIDE_POD} -- curl -IL store-front.default.svc.cluster.local:80

```{{exec}}