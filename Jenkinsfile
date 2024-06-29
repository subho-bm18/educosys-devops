pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'public.ecr.aws/d1z1y5r0/shopping-cart-app:latest'
        ECR_REGISTRY = 'public.ecr.aws/d1z1y5r0'
        ECS_CLUSTER = 'your-ecs-cluster-name'
        ECS_SERVICE = 'your-ecs-service-name'
        AWS_REGION = 'your-aws-region'
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
          //steps {
                //withCredentials([usernamePassword(credentialsId: 'github-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    // Use the credentials
                    //sh 'git clone https://$USERNAME:$PASSWORD@github.com/user/repo.git'
               // }
        //}
        }

      stages {
        stage('Deploy to AWS') {
            steps {
                sh 'aws s3 ls' // Example command to checkk connectivity to aws
            }
        }
    }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    docker.withRegistry("https://${ECR_REGISTRY}", 'ecr:us-east-1:ecr-credentials') {
                        docker.image("${DOCKER_IMAGE}").push()
                    }
                }
            }
        }

        stage('Deploy to ECS') {
            steps {
                script {
                    // Update ECS service to use the new image
                    sh "aws ecs update-service --cluster ${ECS_CLUSTER} --service ${ECS_SERVICE} --force-new-deployment --region ${AWS_REGION}"
                }
            }
        }
    }
}
