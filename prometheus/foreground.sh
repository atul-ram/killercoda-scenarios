echo "Deploying scenario..." && sleep 30

kubectl get pod -n default

kubectl wait --for=condition=ready --timeout=300s pod --all -n default

kubectl get pod -n default


kubectl wait --for=condition=ready --timeout=300s pod --all -n default