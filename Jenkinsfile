pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        ECR_REGISTRY = 'YOUR_ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com'
        ECR_REPOSITORY = 'appointment-service'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        ECR_IMAGE = "${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out repository'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Verifying Docker setup'
                sh 'docker --version'
                sh 'docker info'

                echo 'Building Docker image'
                sh "docker build -t ${ECR_REPOSITORY}:${IMAGE_TAG} ."
            }
        }

        stage('Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-ecr-credentials',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    echo 'Checking AWS CLI setup'
                    sh 'aws --version'
                    sh 'aws sts get-caller-identity'

                    echo 'Logging into ECR'
                    sh "export AWS_DEFAULT_REGION=${AWS_REGION} && aws ecr describe-repositories --repository-names ${ECR_REPOSITORY} --region ${AWS_REGION} || aws ecr create-repository --repository-name ${ECR_REPOSITORY} --region ${AWS_REGION}"
                    sh "export AWS_DEFAULT_REGION=${AWS_REGION} && aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}"

                    echo 'Tagging and pushing image'
                    sh "docker tag ${ECR_REPOSITORY}:${IMAGE_TAG} ${ECR_IMAGE}"
                    sh "docker push ${ECR_IMAGE}"
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed'
        }
    }
}
