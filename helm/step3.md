So far, we have learned how to use the created chart.
Now, let's create my own chart. ( from scratch ＿〆(。╹‿ ╹ 。) )

<br><br><br>

The command to create a new chart is [helm create](https://helm.sh/ko/docs/helm/helm_create/).
Let's create a chart called **my-chart**. 

```bash
controlplane $ helm create my-chart
Creating my-chart
controlplane $ tree my-chart
my-chart
├── Chart.yaml
├── charts
├── templates
│   ├── NOTES.txt
│   ├── _helpers.tpl
│   ├── deployment.yaml
│   ├── hpa.yaml
│   ├── ingress.yaml
│   ├── service.yaml
│   ├── serviceaccount.yaml
│   └── tests
│       └── test-connection.yaml
└── values.yaml

3 directories, 10 files
```

> 💻 Command `helm create my-chart`{{exec}}
> 💻 Command `tree my-chart`{{exec}}

<br><br><br>

As we learned earlier, the chart.yaml file and templates directory have been created.
The templates directory contains manifest files for deployment, service, and ingress.

<br><br><br>

Now, let's modify a few things.
First, let's modify the **service** section in the **values.yaml** file.

Modify it as follows.
```yaml

...omitted...

service:
type: NodePort
port: 80
nodePort: 30007

...omitted...

```

<br>

> 💻 Command `vi ./my-chart/values.yaml`{{exec}}

> Use the vi editor or the web editor in the Editor tab to change it.

<br>

The following are the changed parts. - service.type: ClusterIP -> NodePort - Add service.nodePort <br><br><br> Please also edit the yaml file for service creation.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ include "my-chart.fullname" . }}
  labels:
    {{- include "my-chart.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      {{- if eq .Values.service.type "NodePort" }}
      nodePort: {{ .Values.service.nodePort }}
      {{- end }}
      targetPort: http
      protocol: TCP
      name: http
  selector:
    {{- include "my-chart.selectorLabels" . | nindent 4 }}
```

<br>

> 💻 Command `vi ./my-chart/templates/service.yaml`{{exec}}

> Please change it using vi editor or web editor in Editor tab.

The changed part is as follows.
- Added service.ports.nodePort (line 11 ~ 13)

Please write carefully with indentation.

> It will be created even if only service.type is NodePort.

> In this case, nodePort is automatically assigned a value between **30000~32767**.

> In our example, we modified the chart to specify 30007.

<br><br><br>

And, please delete unnecessary files in the templates directory.

Files deleted from the templates directory will not be created later. 
```bash
controlplane $ rm -r ./my-chart/templates/tests
```

> 💻 Command `rm -r ./my-chart/templates/tests`{{exec}}

<br><br><br>

Now let's check if there are any problems with the part we modified?

```bash
controlplane $ helm lint ./my-chart
==> Linting ./my-chart
[INFO] Chart.yaml: icon is recommended

1 chart(s) linted, 0 chart(s) failed
```

> 💻 Command `helm lint ./my-chart`{{exec}}

<br>

Please correct me if there are any mistakes.

<br><br><br>

Now, my own chart is ready, grammatically correct.

To see which K8s resources are created by your chart, you can use the [Helm Template](https://helm.sh/ko/docs/helm/helm_template/) command.

```bash
controlplane $ helm template my-nginx ./my-chart
---
# Source: my-chart/templates/serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-nginx-my-chart
  labels:
    helm.sh/chart: my-chart-0.1.0
    app.kubernetes.io/name: my-chart
    app.kubernetes.io/instance: my-nginx
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
---
# Source: my-chart/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: my-nginx-my-chart
  labels:
    helm.sh/chart: my-chart-0.1.0
    app.kubernetes.io/name: my-chart
    app.kubernetes.io/instance: my-nginx
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
spec:
  type: NodePort
  ports:
    - port: 80
      nodePort: 30007
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: my-chart
    app.kubernetes.io/instance: my-nginx
---
# Source: my-chart/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-nginx-my-chart
  labels:
    helm.sh/chart: my-chart-0.1.0
    app.kubernetes.io/name: my-chart
    app.kubernetes.io/instance: my-nginx
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: my-chart
      app.kubernetes.io/instance: my-nginx
  template:
    metadata:
      labels:
        app.kubernetes.io/name: my-chart
        app.kubernetes.io/instance: my-nginx
    spec:
      serviceAccountName: my-nginx-my-chart
      securityContext:
        {}
      containers:
        - name: my-chart
          securityContext:
            {}
          image: "nginx:1.16.0"
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
          livenessProbe:
            httpGet:
              path: /
              port: http
          readinessProbe:
            httpGet:
              path: /
              port: http
          resources:
            {}
```

> 💻 Command `helm template my-nginx ./my-chart`{{exec}}

<br>

You can preview the K8s resources that will be generated by the template engine.

Is it as you thought?

If not, you can go back and modify the chart.

This process is the process of developing a chart. (Modify, check, and repeat.)

<br><br><br>

Now, let's install ([helm install](https://helm.sh/ko/docs/helm/helm_install/)) using my chart for the last time.

You can install it right away, but this is also possible.
You can check it in advance before proceeding with the actual installation by using the `--dry-run` option.

```bash
controlplane $ helm install my-nginx --dry-run ./my-chart
NAME: my-nginx
LAST DEPLOYED: Sun Mar 12 03:38:16 2023
NAMESPACE: default
STATUS: pending-install
REVISION: 1
TEST SUITE: None
HOOKS:
MANIFEST:
---
# Source: my-chart/templates/serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-nginx-my-chart
  labels:
    helm.sh/chart: my-chart-0.1.0
    app.kubernetes.io/name: my-chart
    app.kubernetes.io/instance: my-nginx
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
---
# Source: my-chart/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: my-nginx-my-chart
  labels:
    helm.sh/chart: my-chart-0.1.0
    app.kubernetes.io/name: my-chart
    app.kubernetes.io/instance: my-nginx
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
spec:
  type: NodePort
  ports:
    - port: 80
      nodePort: 30007
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: my-chart
    app.kubernetes.io/instance: my-nginx
---
# Source: my-chart/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-nginx-my-chart
  labels:
    helm.sh/chart: my-chart-0.1.0
    app.kubernetes.io/name: my-chart
    app.kubernetes.io/instance: my-nginx
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: my-chart
      app.kubernetes.io/instance: my-nginx
  template:
    metadata:
      labels:
        app.kubernetes.io/name: my-chart
        app.kubernetes.io/instance: my-nginx
    spec:
      serviceAccountName: my-nginx-my-chart
      securityContext:
        {}
      containers:
        - name: my-chart
          securityContext:
            {}
          image: "nginx:1.16.0"
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
          livenessProbe:
            httpGet:
              path: /
              port: http
          readinessProbe:
            httpGet:
              path: /
              port: http
          resources:
            {}

NOTES:
1. Get the application URL by running these commands:
  export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services my-nginx-my-chart)
  export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
  echo http://$NODE_IP:$NODE_PORT
```

> 💻 Command `helm install my-nginx --dry-run ./my-chart`{{exec}}

<br><br><br>

If you have no problems so far, you can proceed with the installation now. 

``` controlplane $ helm install my-nginx ./my-chart NAME: my-nginx LAST DEPLOYED: Sun Mar 12 03:38:35 2023 NAMESPACE: default STATUS: deployed REVISION: 1 TEST SUITE: None NOTES: 1. Get the application URL by running these commands: export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[ 0].nodePort}" services my-nginx-my-chart) export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}") echo http://$NODE_IP:$NODE_PORT 
``` 

> 💻 Command `helm install my-nginx ./my-chart`{{exec}}

Connect and test it. (Connect to NodePort)

🔗 [my-nginx]({{TRAFFIC_HOST1_30007}})

<br><br><br>

It works, right?

So, all that's left is to package my chart.

```
controlplane $ helm package ./my-chart
Successfully packaged chart and saved it to: /root/lab/my-chart-0.1.0.tgz
```

> 💻 Command `helm package ./my-chart`{{exec}}

A file called **my-chart-0.1.0.tgz** will be created.

You can upload it to the helm chart repository or upload it to a place like github and use it.

<br><br><br>

We've learned about Helm so far.

Let's clean up and finish.
```bash
controlplane $ helm uninstall my-nginx
release "my-nginx" uninstalled
```

> 💻 Command `helm uninstall my-nginx`{{exec}}

<br>

After cleaning up, the status is as follows.
```bash
controlplane $ helm list
NAME NAMESPACE REVISION UPDATED STATUS CHART APP VERSION
ubuntu@ip-172-31-28-216:~$
```

> 💻 Command `helm list`{{exec}}

Thank you for your hard work. (〃･ิ‿･ิ)ゞ