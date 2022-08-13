# time-service
A simple flask app for presenting time

## Prerequisites

- K8s cluster
- git
- helm

## Installation

```
$ helm upgrade --install [release-name] jenkins/jenkins
```
For getting the admin secret + expose the deployment locally:
```
$ kubectl exec --namespace jenkins -it svc/[release-name] -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo
$ kubectl --namespace jenkins port-forward svc/[release-name] 8080:8080
```
Go to manage Jenkins -> manage plugins -> available -> docker pipline and install it

## Setting up the pipline

Inside Jenkins UI:
Navigate to new item -> choose pipeline name -> Multibranch pipeline -> ok

In the pipeline configuration under Branch sources -> git -> add the *REPO URL* and add credentials for pulling the code

In the Jenkinsfile, change the SA on line 13 to [release-name]-jenkins and change the remote-registry on lines 46,48 to your registry

### Cluster Prerequisites
For authenticating against GCR create IAM role with sufficient permissions to push & pull from the registry, create and download locally the SA and create k8s secret with it's data:
```
$ kubectl -n jenkins create secret generic gcr-creds --from-file *SA location*
```
Add to the jenkins SA sufficient permissions to deploy to other namespaces:
```
kubectl create clusterrolebinding jenkinsrb --clusterrole=cluster-admin --group=system:serviceaccounts:jenkins --serviceaccount=jenkins:[release-name]
```
Choose a namespace you wish to deploy the services to, create it and apply the following command:
```
kubectl create secret docker-registry gcr-imagepull \
--docker-server=<the registry URL> \
--docker-username=_json_key \
--docker-password="$(cat *SA location*)" \
--docker-email=<your-email>
```
Change accordingly the namespace on line 53 in the Jenkinsfile

Return to the Jenkins UI under dashboard -> your-created-pipline -> press Scan multibranch pipeline
And you should see the job runs the full cycle

for viewing your app
```
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace *your-namespace* -l "app.kubernetes.io/name=services,app.kubernetes.io/instance=services" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace *your-namespace* $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace *your-namespace* port-forward $POD_NAME 8080:$CONTAINER_PORT
```
## Versioning

* [Git](https://git-scm.com/) -  free and open source distributed version control system.

## Authors

* [Yam Peled](https://github.com/yampeled1)
