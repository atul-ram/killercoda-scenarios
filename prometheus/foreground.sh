echo "Deploying scenario..." && sleep 30

kubectl wait --for=condition=ready --timeout=300s get pod -l app.kubernetes.io/name=grafana -n default