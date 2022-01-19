pipeline {
    agent any
    stages {
        stage('PLAN') {
            steps {
                    sh '''terraform init -backend-config=bucket=${TF_VAR_bucket}'''
                    sh 'terraform plan'
            }
        }
        stage('APPLY') {
            steps {
                    sh '''terraform apply --auto-approve'''
            }
        }
    }
}