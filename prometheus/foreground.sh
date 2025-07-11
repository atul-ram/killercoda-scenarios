echo "Deploying scenario..." && sleep 30

kubectl get pod -n default

kubectl wait --for=condition=ready --timeout=150s pod --all -n default

kubectl get pod -n default


kubectl wait --for=condition=ready --timeout=50s pod --all -n default

#kubectl wait --for=condition=ready --timeout=30s pod --all -n default
sleep 5
#kubectl wait --for=condition=ready --timeout=30s pod --all -n default
#sleep 5
kubectl wait --for=condition=ready --timeout=30s pod --all -n default
#kubectl wait --for=condition=ready --timeout=30s pod --all -n default

kubectl get pod -n default

echo "Scenario deployed successfully."
