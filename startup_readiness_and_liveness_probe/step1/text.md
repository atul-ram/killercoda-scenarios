# Step 1: Create the directory structure
mkdir -p kubernetes-concepts/all-probes

# Step 2: Create the all-probes YAML file
```bash
cat <<EOF > kubernetes-concepts/all-probes/all-probes.yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox-all-probes
spec:
  containers:
  - name: busybox
    image: busybox:latest
    command: 
    - "/bin/sh"
    - "-c"
    - |
      echo 'Starting...'; 
      sleep 20; 
      echo 'Creating /tmp/ready'; 
      touch /tmp/ready; 
      echo 'Running for 0 seconds...'; 
      for i in $(seq 1 50); do 
        echo "Running for $i seconds..."; 
        sleep 1; 
      done
    livenessProbe:
      exec:
        command:
        - cat
        - /tmp/ready
      initialDelaySeconds: 30
      periodSeconds: 10
    readinessProbe:
      exec:
        command:
        - cat
        - /tmp/ready
      initialDelaySeconds: 5
      periodSeconds: 10
    startupProbe:
      exec:
        command:
        - cat
        - /tmp/ready
      initialDelaySeconds: 5
      periodSeconds: 10
      failureThreshold: 30
```
### Explanation

- **command**: This command includes `echo` statements and a counter to indicate different phases:
  - `echo 'Starting...'`: Prints "Starting...".
  - `sleep 20`: Simulates a startup delay.
  - `echo 'Creating /tmp/ready'`: Prints "Creating /tmp/ready".
  - `touch /tmp/ready`: Creates the readiness file.
  - `echo 'Running...'`: Prints "Running...".
  - `for i in \$(seq 1 3600); do echo \"Running for \$i seconds...\"; sleep 1; done`: Prints a message every second for 3600 seconds, indicating the container is running.

- **livenessProbe**: Checks for the existence of the file `/tmp/ready` every 10 seconds, starting 30 seconds after the container starts. If this probe fails, Kubernetes will restart the container.
- **readinessProbe**: Checks for the existence of the file `/tmp/ready` every 10 seconds, starting 5 seconds after the container starts. This probe determines if the container is ready to accept traffic.
- **startupProbe**: Checks for the existence of the file `/tmp/ready` every 10 seconds, starting 5 seconds after the container starts, with a failure threshold of 30. This probe is used to determine if the application within the container has started successfully.

### Expected Behavior

1. The BusyBox container will start and immediately print `Starting...`.
2. The container will sleep for 20 seconds.
3. After 20 seconds, the container will print `Creating /tmp/ready` and create the file `/tmp/ready`.
4. The container will then print `Running...` and start a counter.
5. The counter will print a message every second for 3600 seconds, indicating the container is running.
6. The startup probe will check for the existence of the file `/tmp/ready` every 10 seconds, allowing up to 30 failures before considering the container as failed.
7. Once the file `/tmp/ready` is created, the readiness probe will determine if the container is ready to accept traffic.
8. The liveness probe will periodically check if the container is still running and healthy by checking the existence of the file `/tmp/ready`.

To apply this configuration, you can use the following command:

```bash
kubectl apply -f kubernetes-concepts/all-probes/all-probes.yaml
```

You can then monitor the pod logs and status with:

```bash
kubectl get pods -w
kubectl logs -f busybox-all-probes
```

This will show you the pod's status and the output of the `echo` statements and the counter, making it clear when each phase is happening.
