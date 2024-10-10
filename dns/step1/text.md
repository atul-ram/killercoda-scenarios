#

## Steps to Test the Scenario

Below are the detailed steps to ensure your pod can communicate using DNS within a Kubernetes cluster:

### Step 1: Ensure DNS Tools are Available in the Pod

BusyBox typically comes with `nslookup` and `wget` which are sufficient for basic DNS resolution and HTTP requests.

First, create two namespaces: namespace-a and namespace-b.

```bash
kubectl create namespace namespace-a
kubectl create namespace namespace-b
```

### Step 2: Verify the Cluster DNS Add-on

Ensure that the DNS add-on (`kube-dns` or `CoreDNS`) is running in your cluster. Usually, this is set up by default in most Kubernetes distributions.

Check if the DNS pods are running:

```bash
kubectl get pods -n kube-system -l k8s-app=kube-dns
```

### Step 3: Create and Configure Services

Ensure you have created services for your pods. These services will have DNS entries created automatically by Kubernetes.

### Step 4: Test DNS Resolution in the Pod

You can test DNS resolution by running commands directly in the pod. Here’s how you can do it:

1. **Deploy the BusyBox Pod in `namespace-a` with HTTP Server**:

Apply the deployment:

```bash
kubectl apply -f assets/mc1-deployment.yaml
```

1. **Deploy the Service for BusyBox in `namespace-a`**:


Apply the service:

```bash
kubectl apply -f assets/mc1-service.yaml
```

2. **Deploy the BusyBox Pod in `namespace-b` to Communicate with `namespace-a`**:


Apply the deployment:

```bash
kubectl apply -f assets/busybox-deployment-b.yaml
```

3. **Test DNS Resolution by Executing into the Pod in `namespace-b`**:

```bash
kubectl exec -it <pod-name> -n namespace-b -- sh
```

Inside the pod, test DNS resolution:

```sh
nslookup mc1-service-a.namespace-a.svc.cluster.local
```

You should see the DNS resolution output with the IP address of the service.

![alt text](image.png)

### Step 5: Check another command for Communication Verification

Finally, check the output of command below to verify communication:

```sh
 wget -qO- http://mc1-service-a.namespace-a.svc.cluster.local
````

you should see message printed in html page.

By following these steps, you ensure that your pod image is capable of DNS communication within a Kubernetes cluster, and you verify that the DNS resolution is working correctly.
