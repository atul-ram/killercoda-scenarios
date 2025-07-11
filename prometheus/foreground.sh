echo "Deploying scenario..." && sleep 10

kubectl wait --for=condition=ready --timeout=3000s get pod -l app.kubernetes.io/name=grafana -n default