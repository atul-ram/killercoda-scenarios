set -x # to test stderr output in /var/log/killercoda
echo starting... # to test stdout output in /var/log/killercoda
sleep 3
mkdir -p ~/lab
curl -o ~/lab/busybox-deployment-b.yaml https://raw.githubusercontent.com/atul-ram/killercoda-scenarios/refs/heads/main/dns/assets/busybox-deployment-b.yaml
curl -o ~/lab/mc1-deployment.yaml https://raw.githubusercontent.com/atul-ram/killercoda-scenarios/refs/heads/main/dns/assets/mc1-deployment.yaml
curl -o ~/lab/mc1-service.yaml https://raw.githubusercontent.com/atul-ram/killercoda-scenarios/refs/heads/main/dns/assets/mc1-service.yaml
echo done > /tmp/background0