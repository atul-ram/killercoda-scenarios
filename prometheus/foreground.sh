echo "Deploying scenario..." && sleep 50

kubectl get pod -n default

kubectl wait --for=condition=ready  pod --all -n default

kubectl get pod -n default

echo "Scenario deployed successfully."

kubectl patch svc prometheus-grafana -p '{"spec": {"type": "NodePort", "ports": [{"port": 80, "nodePort": 30000}]}}'

echo "Grafana service patched to NodePort on port 30000."