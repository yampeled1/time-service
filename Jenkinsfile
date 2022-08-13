pipeline {
  agent {
    kubernetes {
      label 'service-demo'
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
metadata:
labels:
  component: ci
spec:
  serviceAccountName: yamp-jenkins
  containers:
  - name: docker
    image: docker:latest
    command:
    - cat
    tty: true
    volumeMounts:
    - mountPath: /var/run/docker.sock
      name: docker-sock
    - name: docker-creds
      mountPath: /etc/secret
      readOnly: true
  volumes:
    - name: docker-sock
      hostPath:
        path: /var/run/docker.sock
    - name: docker-creds
      secret:
        secretName: gcr-creds
"""
    }
  }
  stages {
    stage('Build') {
      steps {
        container('docker') {
          sh """
            docker build -t europe-west2-docker.pkg.dev/yamp-playground/yamp-registry/facts-service:$BUILD_NUMBER .
            cat /etc/secret/gcr-creds.json | docker login -u _json_key --password-stdin https://europe-west2-docker.pkg.dev
            docker push europe-west2-docker.pkg.dev/yamp-playground/yamp-registry/facts-service:$BUILD_NUMBER
          """
          }
        }
    }
  }
}