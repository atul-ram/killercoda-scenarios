

try sending a request to the store-front service:

Run the following command to get the name of the test pod.

```bash
CURL_POD_NAME="$(kubectl get pod -l app=curl -o jsonpath="{.items[0].metadata.name}")"
while [[ -z "${CURL_POD_NAME}" || "$(kubectl get pod ${CURL_POD_NAME} -o jsonpath='{.status.phase}')" != "Running" ]]; do
  echo "Waiting for curl pod to be ready..."
  sleep 2
  CURL_POD_NAME="$(kubectl get pod -l app=curl -o jsonpath="{.items[0].metadata.name}")"
done
kubectl exec -it ${CURL_POD_NAME} -- curl -IL store-front.default.svc.cluster.local:80

kubectl exec -it tester -- \
    bash -c 'for i in {1..2}; \
                do curl -s -X POST http://store-front.default.svc.cluster.local; \
                echo; \
            done;'

```{{exec}}

Now, enforce strict mTLS for all services in the namespace:

```bash
kubectl apply  -f - <<EOF
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: pets-mtls
  namespace: default
spec:
  mtls:
    mode: STRICT
EOF
```{{exec}}
