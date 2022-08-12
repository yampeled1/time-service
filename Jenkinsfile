
version="1.0.0"
repository="time-service"
tag="latest"
image="${repository}:${version}.${env.BUILD_NUMBER}"
namespace="apps"

podTemplate(label: 'demo-pipeline-pod', cloud: 'kubernetes', serviceAccount: 'jenkins',
  containers: [
    containerTemplate(name: 'jnlp', image: 'jenkins/inbound-agent:4.11.2-4', ttyEnabled: false, command: 'sleep'),
    containerTemplate(name: 'docker', image: 'docker:git', ttyEnabled: true, command: 'cat', privileged: true)
  ],
  volumes: [
    hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock')
  ]) {
    node('demo-customer-pod') {
        stage('Prepare') {
            checkout scm
        }

        stage('Build Docker Image') {
            container('docker') {
                sh """
                  docker build -t ${image} .
                """
            }
        }
    }
}