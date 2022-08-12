
pipeline {
  agent {
    kubernetes {
      label 'multiple labels'
      containerTemplate {
        name 'docker'
        image 'docker:git'
        command 'sleep'
        args '9999999'
      }
      podRetention onFailure()
    }
  }
  environment {
    CONTAINER_ENV_VAR = 'container-env-var-value'
  }
  stages {
    stage('Run maven') {
      steps {
        sh 'git clone https://github.com/yampeled1/time-service.git'
        sh 'docker build .'
        }
      }
    }
  }
}