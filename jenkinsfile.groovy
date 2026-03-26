pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
        AWS_DEFAULT_REGION    = 'us-east-1'
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/awsbatch/jenkins-terraform-eks-deployment.git'
            }
        }
        stage('Terraform init') {
            steps {
                dir('EKS') {
                sh '''
                rm -rf .terraform .terraform.lock.hcl
                terraform init
                '''
                }
            }
        }
        stage('Terraform fmt') {
            steps {
                dir('EKS') {
                    sh 'terraform fmt'
                }
            }
        }
        stage('Terraform plan') {
            steps {
                dir('EKS') {
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform apply') {
            steps {
                dir('EKS') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
}
}