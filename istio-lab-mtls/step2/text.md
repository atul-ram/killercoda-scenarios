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

Once the pod is running, check for istio pod

```bash

pods=$(kubectl get pods -l app=curl -o jsonpath='{.items[*].metadata.name}')

for pod in $pods; do
  containers=$(kubectl get pod $pod -o jsonpath='{.spec.containers[*].name}')
  if [[ $containers == *"istio-proxy"* ]]; then
    echo "Pod '$pod' contains the container 'istio-proxy'."
  else
    echo "Pod '$pod' does NOT contain the container 'istio-proxy'."
  fi
done

```{{exec}}
