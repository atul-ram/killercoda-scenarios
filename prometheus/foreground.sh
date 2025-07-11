echo "Deploying scenario..." && sleep 10

kubectl wait --for=condition=ready --timeout=300s pod -l release=prometheus -n default