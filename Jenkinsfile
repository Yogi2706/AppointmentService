pipeline {
    agent any

    environment {
        CI = 'true'
        NODE_ENV = 'test'
    }

    tools {
        nodejs 'Node18'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code'
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                echo 'Installing npm dependencies'
                sh 'npm install'
            }
        }

        stage('Lint Code') {
            steps {
                echo 'Checking code quality'
                sh 'npm run lint'
            }
        }

        stage('Run Tests') {
            steps {
                echo 'Running unit tests'
                sh 'npm test'
            }
        }

        stage('Archive Coverage') {
            steps {
                echo 'Archiving test coverage output'
                archiveArtifacts artifacts: 'coverage/**', allowEmptyArchive: true
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished'
        }
        success {
            echo 'AppointmentService pipeline succeeded'
        }
        failure {
            echo 'AppointmentService pipeline failed'
        }
    }
}
