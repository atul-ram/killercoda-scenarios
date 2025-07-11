echo "Deploying scenario..." && sleep 30

kubectl get pod -n default

kubectl wait --for=condition=ready --timeout=30s pod --all -n default

kubectl get pod -n default


kubectl wait --for=condition=ready --timeout=30s pod --all -n default

kubectl wait --for=condition=ready --timeout=30s pod --all -n default
kubectl wait --for=condition=ready --timeout=30s pod --all -n default
kubectl wait --for=condition=ready --timeout=30s pod --all -n default
kubectl wait --for=condition=ready --timeout=30s pod --all -n default

kubectl get pod -n default

echo "Scenario deployed successfully."

echo "You can port-forward the Prometheus server to access it locally:"
echo "kubectl port-forward svc/prometheus-server 9090:80 -n default"
echo "Then visit http://localhost:9090 in your web browser."