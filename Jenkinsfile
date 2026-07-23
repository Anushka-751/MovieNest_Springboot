pipeline {
    agent any

    parameters {
        choice(
            name: 'ACTION',
            choices: ['DEPLOY', 'REMOVE'],
            description: 'Choose whether to deploy or remove containers'
        )
    }

    tools {
        maven 'maven'
    }

    environment {
        APP_NAME = "springboot-app"
    }

    stages {
        stage('Build JAR') {
            when {
                expression { params.ACTION == 'DEPLOY' }
            }
            steps {
                echo "Building Spring Boot JAR..."
                sh 'mvn clean package'
            }
        }
         stage('Docker Tag the Image') {
            steps {
                echo "Tagging the Docker image..."
                sh 'sudo docker tag movie-cicd-docker anuu15/movie-cicd-docker:latest'
            }
            post {
                success {
                    echo 'Docker image tagged successfully.'
                }
                failure {
                    echo 'Failed to tag Docker image.'
                }
            }
        }
        stage('Docker Push the Image') {
            steps {
                echo "Pushing the Docker image to DockerHub..."
                sh 'sudo docker push anuu15/movie-cicd-docker:latest'
            }
            post {
                success {
                    echo 'Docker image pushed to DockerHub successfully.'
                }
                failure {
                    echo 'Failed to push Docker image to DockerHub.'
                }
            }
        }
        stage('Cleanup Local Docker Images') {
            steps {
                echo "Cleaning up local Docker images..."
                sh '''
                    sudo docker rmi anuu15/movie-cicd-docker:latest
                    sudo docker rmi movie-cicd-docker
                '''
            }
            post {
                success {
                    echo 'Local Docker images cleaned up successfully.'
                }
                failure {
                    echo 'Failed to clean up local Docker images.'
                }
            }
        }
        stage('Done') {
            steps {
                echo "Pipeline execution completed."
            }
        }
        stage('Docker Logout from DockerHub') {
            steps {
                echo "Logging out from DockerHub..."
                sh 'sudo docker logout'
            }
        }
        stage('Deploy Application') {
            when {
                expression { params.ACTION == 'DEPLOY' }
            }
            steps {
                echo "Deploying Docker Containers..."
                sh 'docker compose up --build -d'
            }
        }

        stage('Remove Application') {
            when {
                expression { params.ACTION == 'REMOVE' }
            }
            steps {
                echo "Stopping and Removing Containers..."
                sh 'docker compose down'
                sh 'docker image prune -af'
            }
        }
    }
    post {
        success {
            echo "Pipeline executed successfully..."
        }
        failure {
            echo "Pipeline execution failed..."
        }
        always {
            echo "Pipeline completed..."
        }
    }
}
