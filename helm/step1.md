Let's practice frequently used Helm commands.
First, let's take a look at what commands there are.

```bash
controlplane $ helm --help
The Kubernetes package manager

Common actions for Helm:

- helm search:    search for charts
- helm pull:      download a chart to your local directory to view
- helm install:   upload the chart to Kubernetes
- helm list:      list releases of charts

Environment variables:

...omitted...

Helm stores cache, configuration, and data based on the following configuration order:

- If a HELM_*_HOME environment variable is set, it will be used
- Otherwise, on systems supporting the XDG base directory specification, the XDG variables will be used
- When no other location is set a default location will be used based on the operating system

By default, the default directories depend on the Operating System. The defaults are listed below:

| Operating System | Cache Path                | Configuration Path             | Data Path               |
|------------------|---------------------------|--------------------------------|-------------------------|
| Linux            | $HOME/.cache/helm         | $HOME/.config/helm             | $HOME/.local/share/helm |
| macOS            | $HOME/Library/Caches/helm | $HOME/Library/Preferences/helm | $HOME/Library/helm      |
| Windows          | %TEMP%\helm               | %APPDATA%\helm                 | %APPDATA%\helm          |

Usage:
  helm [command]

Available Commands:
  completion  generate autocompletion scripts for the specified shell
  create      create a new chart with the given name
  dependency  manage a chart's dependencies

...생략...

Use "helm [command] --help" for more information about a command.
```

> 💻 Command `helm --help`{{exec}}

<br><br><br>

**Common actions for Helm** Should we try the commands one by one?

```bash
Common actions for Helm:

- helm search:    search for charts
- helm pull:      download a chart to your local directory to view
- helm install:   upload the chart to Kubernetes
- helm list:      list releases of charts
```

The first one is `helm search`, but before that, you need to add **helm repository** first.
```bash
controlplane $ helm repo add bitnami https://charts.bitnami.com/bitnami
"bitnami" has been added to your repositories
```

> 💻 Command `helm repo add bitnami https://charts.bitnami.com/bitnami`{{exec}}

<br><br><br>

You can also see the list of repositories.
```bash
controlplane $ helm repo list
NAME    URL                               
bitnami https://charts.bitnami.com/bitnami
```

> 💻 Command `helm repo list`{{exec}}

<br><br><br>

Now searchable (`helm search`).
```bash
controlplane $ helm search repo bitnami
NAME                                            CHART VERSION   APP VERSION     DESCRIPTION                                       
bitnami/airflow                                 14.0.13         2.5.1           Apache Airflow is a tool to express and execute...
bitnami/apache                                  9.2.17          2.4.55          Apache HTTP Server is an open-source HTTP serve...
bitnami/appsmith                                0.1.15          1.9.9           Appsmith is an open source platform for buildin...
bitnami/argo-cd                                 4.4.12          2.6.3           Argo CD is a continuous delivery tool for Kuber...
bitnami/argo-workflows                          5.1.11          3.4.5           Argo Workflows is meant to orchestrate Kubernet...
bitnami/aspnet-core                             4.0.7           7.0.3           ASP.NET Core is an open-source framework for we...
bitnami/cassandra                               10.0.4          4.1.0           Apache Cassandra is an open source distributed ...
bitnami/cert-manager                            0.9.2           1.11.0          cert-manager is a Kubernetes add-on to automate...
bitnami/clickhouse                              3.0.5           23.2.2          ClickHouse is an open-source column-oriented OL...
bitnami/common                                  2.2.3           2.2.3           A Library Helm Chart for grouping common logic ...
bitnami/concourse                               2.0.5           7.9.1           Concourse is an automation system written in Go...
bitnami/consul                                  10.9.12         1.14.4          HashiCorp Consul is a tool for discovering and ...
bitnami/contour                                 11.0.1          1.24.1          Contour is an open source Kubernetes ingress co...
bitnami/contour-operator                        4.0.1           1.24.0          The Contour Operator extends the Kubernetes API...
...생략...
```

> 💻 Command `helm search repo bitnami`{{exec}}

<br><br><br>

Should I take a look at Wordpress?
```bash
controlplane $ helm search repo wordpress
NAME                    CHART VERSION   APP VERSION     DESCRIPTION                                       
bitnami/wordpress       15.2.48         6.1.1           WordPress is the world's most popular blogging ...
bitnami/wordpress-intel 2.1.31          6.1.1           DEPRECATED WordPress for Intel is the most popu...
```

> 💻 Command `helm search repo wordpress`{{exec}}

<br><br><br>

다음은 `helm pull` Command 입니다.  
This is a command to download (pull) the Helm chart registered in the **Helm repository**.
```bash
controlplane $ helm pull bitnami/wordpress 
controlplane $ ls wordpress*
wordpress-15.2.48.tgz
```

> 💻 Command `helm pull bitnami/wordpress`{{exec}}  
> 💻 Command `ls wordpress*`{{exec}}

<br><br><br>

It's received as a tar file. Should I unzip it?

```bash
controlplane $ tar -xvf wordpress*.tgz
wordpress/Chart.yaml
wordpress/Chart.lock
wordpress/values.yaml
wordpress/values.schema.json
wordpress/templates/NOTES.txt
wordpress/templates/_helpers.tpl
wordpress/templates/config-secret.yaml
wordpress/templates/deployment.yaml
...생략...
```

> 💻 Command `tar -xvf wordpress*.tgz`{{exec}}

<br><br><br>

Let's take a look at what files there are.

Before that, let's install tree.

```bash
controlplane $ sudo apt-get update && sudo apt-get install tree
Hit:2 http://ppa.launchpad.net/rmescandon/yq/ubuntu focal InRelease 
Hit:3 http://archive.ubuntu.com/ubuntu focal InRelease              
Get:4 http://security.ubuntu.com/ubuntu focal-security InRelease [114 kB]
Get:1 https://packages.cloud.google.com/apt kubernetes-xenial InRelease [8993 B]
Get:5 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 Packages [64.1 kB]
Get:6 http://archive.ubuntu.com/ubuntu focal-updates InRelease [114 kB]                  
Get:7 http://security.ubuntu.com/ubuntu focal-security/main amd64 Packages [2038 kB]
Get:8 http://archive.ubuntu.com/ubuntu focal-backports InRelease [108 kB]
Get:9 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 Packages [2424 kB]
Get:10 http://security.ubuntu.com/ubuntu focal-security/main Translation-en [331 kB]
Get:11 http://security.ubuntu.com/ubuntu focal-security/main amd64 c-n-f Metadata [12.2 kB]     
Get:12 http://security.ubuntu.com/ubuntu focal-security/restricted amd64 Packages [1556 kB]      
Get:13 http://security.ubuntu.com/ubuntu focal-security/restricted Translation-en [219 kB] 
Get:14 http://security.ubuntu.com/ubuntu focal-security/universe amd64 Packages [808 kB]                
Get:15 http://security.ubuntu.com/ubuntu focal-security/universe Translation-en [160 kB]                
Get:16 http://security.ubuntu.com/ubuntu focal-security/universe amd64 c-n-f Metadata [17.2 kB]     
Get:17 http://archive.ubuntu.com/ubuntu focal-updates/main Translation-en [413 kB]                     
Get:18 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 c-n-f Metadata [16.3 kB]
Get:19 http://archive.ubuntu.com/ubuntu focal-updates/restricted amd64 Packages [1663 kB]
Get:20 http://archive.ubuntu.com/ubuntu focal-updates/restricted Translation-en [234 kB]
Get:21 http://archive.ubuntu.com/ubuntu focal-updates/restricted amd64 c-n-f Metadata [620 B]
Get:22 http://archive.ubuntu.com/ubuntu focal-updates/universe amd64 Packages [1034 kB]
Get:23 http://archive.ubuntu.com/ubuntu focal-updates/universe Translation-en [242 kB]
Get:24 http://archive.ubuntu.com/ubuntu focal-updates/universe amd64 c-n-f Metadata [23.7 kB]                                                    
Get:25 http://archive.ubuntu.com/ubuntu focal-updates/multiverse amd64 Packages [25.2 kB]                                                        
Get:26 http://archive.ubuntu.com/ubuntu focal-updates/multiverse amd64 c-n-f Metadata [592 B]                                                    
Get:27 http://archive.ubuntu.com/ubuntu focal-backports/universe amd64 Packages [25.0 kB]                                                        
Get:28 http://archive.ubuntu.com/ubuntu focal-backports/universe amd64 c-n-f Metadata [880 B]                                                    
Fetched 11.6 MB in 6s (1901 kB/s)                                                                                                                
Reading package lists... Done
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following NEW packages will be installed:
  tree
0 upgraded, 1 newly installed, 0 to remove and 96 not upgraded.
Need to get 43.0 kB of archives.
After this operation, 115 kB of additional disk space will be used.
Get:1 http://archive.ubuntu.com/ubuntu focal/universe amd64 tree amd64 1.8.0-1 [43.0 kB]
Fetched 43.0 kB in 1s (46.9 kB/s)
Selecting previously unselected package tree.
(Reading database ... 72923 files and directories currently installed.)
Preparing to unpack .../tree_1.8.0-1_amd64.deb ...
Unpacking tree (1.8.0-1) ...
Setting up tree (1.8.0-1) ...
Processing triggers for man-db (2.9.1-1) ...
```

> 💻 Command `sudo apt-get update && sudo apt-get install tree`{{exec}}

<br><br><br>

Run the tree command.
```bash
controlplane $ tree ./wordpress
./wordpress
|-- Chart.lock
|-- Chart.yaml
|-- README.md
|-- charts
|   |-- common
|   |   |-- Chart.yaml
|   |   |-- README.md
|   |   |-- templates
|   |   |   |-- _affinities.tpl
|   |   |   |-- _capabilities.tpl
|   |   |   |-- _errors.tpl
|   |   |   |-- _images.tpl
|   |   |   |-- _ingress.tpl
|   |   |   |-- _labels.tpl
|   |   |   |-- _names.tpl
|   |   |   |-- _secrets.tpl
|   |   |   |-- _storage.tpl
|   |   |   |-- _tplvalues.tpl
|   |   |   |-- _utils.tpl
|   |   |   |-- _warnings.tpl
|   |   |   `-- validations
|   |   |       |-- _cassandra.tpl
|   |   |       |-- _mariadb.tpl
|   |   |       |-- _mongodb.tpl
|   |   |       |-- _mysql.tpl
|   |   |       |-- _postgresql.tpl
|   |   |       |-- _redis.tpl
|   |   |       `-- _validations.tpl
|   |   `-- values.yaml
|   |-- mariadb
|   |   |-- Chart.lock
|   |   |-- Chart.yaml
|   |   |-- README.md
|   |   |-- charts
|   |   |   `-- common
|   |   |       |-- Chart.yaml
|   |   |       |-- README.md
|   |   |       |-- templates
|   |   |       |   |-- _affinities.tpl
|   |   |       |   |-- _capabilities.tpl
|   |   |       |   |-- _errors.tpl
|   |   |       |   |-- _images.tpl
|   |   |       |   |-- _ingress.tpl
|   |   |       |   |-- _labels.tpl
|   |   |       |   |-- _names.tpl
|   |   |       |   |-- _secrets.tpl
|   |   |       |   |-- _storage.tpl
|   |   |       |   |-- _tplvalues.tpl
|   |   |       |   |-- _utils.tpl
|   |   |       |   |-- _warnings.tpl
|   |   |       |   `-- validations
|   |   |       |       |-- _cassandra.tpl
|   |   |       |       |-- _mariadb.tpl
|   |   |       |       |-- _mongodb.tpl
|   |   |       |       |-- _mysql.tpl
|   |   |       |       |-- _postgresql.tpl
|   |   |       |       |-- _redis.tpl
|   |   |       |       `-- _validations.tpl
|   |   |       `-- values.yaml
|   |   |-- templates
|   |   |   |-- NOTES.txt
|   |   |   |-- _helpers.tpl
|   |   |   |-- extra-list.yaml
|   |   |   |-- networkpolicy-egress.yaml
|   |   |   |-- primary
|   |   |   |   |-- configmap.yaml
|   |   |   |   |-- initialization-configmap.yaml
|   |   |   |   |-- networkpolicy-ingress.yaml
|   |   |   |   |-- pdb.yaml
|   |   |   |   |-- statefulset.yaml
|   |   |   |   `-- svc.yaml
|   |   |   |-- prometheusrules.yaml
|   |   |   |-- role.yaml
|   |   |   |-- rolebinding.yaml
|   |   |   |-- secondary
|   |   |   |   |-- configmap.yaml
|   |   |   |   |-- networkpolicy-ingress.yaml
|   |   |   |   |-- pdb.yaml
|   |   |   |   |-- statefulset.yaml
|   |   |   |   `-- svc.yaml
|   |   |   |-- secrets.yaml
|   |   |   |-- serviceaccount.yaml
|   |   |   `-- servicemonitor.yaml
|   |   |-- values.schema.json
|   |   `-- values.yaml
|   `-- memcached
|       |-- Chart.lock
|       |-- Chart.yaml
|       |-- README.md
|       |-- charts
|       |   `-- common
|       |       |-- Chart.yaml
|       |       |-- README.md
|       |       |-- templates
|       |       |   |-- _affinities.tpl
|       |       |   |-- _capabilities.tpl
|       |       |   |-- _errors.tpl
|       |       |   |-- _images.tpl
|       |       |   |-- _ingress.tpl
|       |       |   |-- _labels.tpl
|       |       |   |-- _names.tpl
|       |       |   |-- _secrets.tpl
|       |       |   |-- _storage.tpl
|       |       |   |-- _tplvalues.tpl
|       |       |   |-- _utils.tpl
|       |       |   |-- _warnings.tpl
|       |       |   `-- validations
|       |       |       |-- _cassandra.tpl
|       |       |       |-- _mariadb.tpl
|       |       |       |-- _mongodb.tpl
|       |       |       |-- _mysql.tpl
|       |       |       |-- _postgresql.tpl
|       |       |       |-- _redis.tpl
|       |       |       `-- _validations.tpl
|       |       `-- values.yaml
|       |-- templates
|       |   |-- NOTES.txt
|       |   |-- _helpers.tpl
|       |   |-- deployment.yaml
|       |   |-- extra-list.yaml
|       |   |-- hpa.yaml
|       |   |-- metrics-svc.yaml
|       |   |-- pdb.yaml
|       |   |-- secrets.yaml
|       |   |-- service.yaml
|       |   |-- serviceaccount.yaml
|       |   |-- servicemonitor.yaml
|       |   `-- statefulset.yaml
|       `-- values.yaml
|-- templates
|   |-- NOTES.txt
|   |-- _helpers.tpl
|   |-- config-secret.yaml
|   |-- deployment.yaml
|   |-- externaldb-secrets.yaml
|   |-- extra-list.yaml
|   |-- hpa.yaml
|   |-- httpd-configmap.yaml
|   |-- ingress.yaml
|   |-- metrics-svc.yaml
|   |-- networkpolicy-backend-ingress.yaml
|   |-- networkpolicy-egress.yaml
|   |-- networkpolicy-ingress.yaml
|   |-- pdb.yaml
|   |-- postinit-configmap.yaml
|   |-- pvc.yaml
|   |-- secrets.yaml
|   |-- serviceaccount.yaml
|   |-- servicemonitor.yaml
|   |-- svc.yaml
|   `-- tls-secrets.yaml
|-- values.schema.json
`-- values.yaml

19 directories, 134 files
```

> 💻 Command `tree ./wordpress`{{exec}}

<br><br><br>

Now let's proceed with the installation (`helm install`).
```bash
controlplane $ helm repo update
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "bitnami" chart repository
Update Complete. ⎈Happy Helming!⎈
```

> 💻 Command `helm repo update`{{exec}}

<br><br><br>

```bash
controlplane $ helm install my-wordpress bitnami/wordpress
NAME: my-wordpress
LAST DEPLOYED: Sat Mar  4 08:10:00 2023
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: wordpress
CHART VERSION: 15.2.48
APP VERSION: 6.1.1

** Please be patient while the chart is being deployed **

Your WordPress site can be accessed through the following DNS name from within your cluster:

    my-wordpress.default.svc.cluster.local (port 80)

To access your WordPress site from outside the cluster follow the steps below:

1. Get the WordPress URL by running these commands:

  NOTE: It may take a few minutes for the LoadBalancer IP to be available.
        Watch the status with: 'kubectl get svc --namespace default -w my-wordpress'

   export SERVICE_IP=$(kubectl get svc --namespace default my-wordpress --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
   echo "WordPress URL: http://$SERVICE_IP/"
   echo "WordPress Admin URL: http://$SERVICE_IP/admin"

2. Open a browser and access WordPress using the obtained URL.

3. Login with the following credentials below to see your blog:

  echo Username: user
  echo Password: $(kubectl get secret --namespace default my-wordpress -o jsonpath="{.data.wordpress-password}" | base64 -d)
```

> 💻 Command `helm install my-wordpress bitnami/wordpress`{{exec}}

<br><br><br>

The installed Helm chart is called **[Release](https://helm.sh/ko/docs/glossary/#release)**.
You can check the list of **Release** with the `helm list` command.

```bash
controlplane $ helm list
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
my-wordpress    default         1               2023-03-04 08:10:00.920221878 +0000 UTC deployed        wordpress-15.2.48       6.1.1
```

> 💻 Command `helm list`{{exec}}

<br><br><br>

Let's see what resources were created with Kubernetes Command.
```bash
controlplane $ kubectl get all
NAME                                READY   STATUS    RESTARTS   AGE
pod/my-wordpress-78bdbdf8dd-ndp4n   1/1     Running   0          2m7s
pod/my-wordpress-mariadb-0          1/1     Running   0          2m7s

NAME                           TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
service/kubernetes             ClusterIP      10.96.0.1        <none>        443/TCP                      8d
service/my-wordpress           LoadBalancer   10.100.238.105   <pending>     80:31507/TCP,443:31326/TCP   2m7s
service/my-wordpress-mariadb   ClusterIP      10.99.133.6      <none>        3306/TCP                     2m7s

NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/my-wordpress   1/1     1            1           2m7s

NAME                                      DESIRED   CURRENT   READY   AGE
replicaset.apps/my-wordpress-78bdbdf8dd   1         1         1       2m7s

NAME                                    READY   AGE
statefulset.apps/my-wordpress-mariadb   1/1     2m7s
```

> 💻 Command `kubectl get all`{{exec}}

<br><br><br>

Wow~ It looks like everything needed for Wordpress software is installed at once. As a package...

You can also delete it at once.
```bash
controlplane $ helm uninstall my-wordpress
release "my-wordpress" uninstalled
```

> 💻 Command `helm uninstall my-wordpress`{{exec}}

<br>

After cleaning, the status is as follows.
```bash
controlplane $ helm list
NAME    NAMESPACE       REVISION        UPDATED STATUS  CHART   APP VERSION
controlplane $
```

> 💻 Command `helm list`{{exec}}