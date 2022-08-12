pipeline {
    agent { any { image 'docker:git' } }
    stages {
        stage('build') {
            steps {
                sh 'docker build .'
            }
        }
    }
}
