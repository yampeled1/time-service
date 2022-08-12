pipeline {
    agent { docker { image 'docker:git' } }
    stages {
        stage('build') {
            steps {
                sh 'docker build .'
            }
        }
    }
}
