echo "Deploying scenario..." && sleep 30

kubectl wait --for=condition=ready --timeout=300s pod --all -n default