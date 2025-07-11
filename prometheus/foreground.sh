echo "Deploying scenario..." && sleep 10

kubectl wait --for=condition=ready --timeout=3000s pod -l app.kubernetes.io/name=grafana -n default