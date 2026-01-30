pipeline {
    agent any
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKERHUB_USERNAME = 'subhaniuduwawala'
        BACKEND_IMAGE = "${DOCKERHUB_USERNAME}/lawpoint-backend"
        FRONTEND_IMAGE = "${DOCKERHUB_USERNAME}/lawpoint-frontend"
        GIT_COMMIT_SHORT = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
        SERVER_IP = '44.214.128.112'
    }
    
    parameters {
        booleanParam(name: 'DEPLOY_TO_AWS', defaultValue: false, description: 'Deploy to AWS EC2 after building?')
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code...'
                checkout scm
            }
        }
        
        stage('Setup Docker Buildx') {
            steps {
                echo 'Setting up Docker Buildx...'
                sh '''
                    docker buildx version || {
                        echo "Installing Docker Buildx..."
                        docker buildx create --use --name mybuilder || true
                        docker buildx inspect --bootstrap
                    }
                '''
            }
        }
        
        stage('Login to Docker Hub') {
            steps {
                echo 'Logging in to Docker Hub...'
                sh '''
                    echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                '''
            }
        }
        
        stage('Build Backend Image') {
            steps {
                echo 'Building backend Docker image...'
                dir('backend') {
                    sh """
                        docker buildx build \
                            --tag ${BACKEND_IMAGE}:latest \
                            --tag ${BACKEND_IMAGE}:${GIT_COMMIT_SHORT} \
                            --cache-from type=registry,ref=${BACKEND_IMAGE}:latest \
                            --cache-to type=inline \
                            --load \
                            .
                    """
                }
            }
        }
        
        stage('Build Frontend Image') {
            steps {
                echo 'Building frontend Docker image...'
                dir('frontend') {
                    sh """
                        docker buildx build \
                            --tag ${FRONTEND_IMAGE}:latest \
                            --tag ${FRONTEND_IMAGE}:${GIT_COMMIT_SHORT} \
                            --cache-from type=registry,ref=${FRONTEND_IMAGE}:latest \
                            --cache-to type=inline \
                            --load \
                            .
                    """
                }
            }
        }
        
        stage('Push Backend Image') {
            steps {
                echo 'Pushing backend image to Docker Hub...'
                sh """
                    docker push ${BACKEND_IMAGE}:latest
                    docker push ${BACKEND_IMAGE}:${GIT_COMMIT_SHORT}
                """
            }
        }
        
        stage('Push Frontend Image') {
            steps {
                echo 'Pushing frontend image to Docker Hub...'
                sh """
                    docker push ${FRONTEND_IMAGE}:latest
                    docker push ${FRONTEND_IMAGE}:${GIT_COMMIT_SHORT}
                """
            }
        }
        
        stage('Summary') {
            steps {
                echo '========================================='
                echo 'Docker Images Built and Pushed!'
                echo '========================================='
                echo "Backend: ${BACKEND_IMAGE}:latest"
                echo "Backend: ${BACKEND_IMAGE}:${GIT_COMMIT_SHORT}"
                echo "Frontend: ${FRONTEND_IMAGE}:latest"
                echo "Frontend: ${FRONTEND_IMAGE}:${GIT_COMMIT_SHORT}"
                echo '========================================='
            }
        }
        
        stage('Deploy to AWS') {
            when {
                expression { params.DEPLOY_TO_AWS == true }
            }
            steps {
                echo 'Deploying to AWS EC2...'
                sshagent(credentials: ['lawpoint-ssh-key']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@${SERVER_IP} '
                            cd /home/ubuntu/lawpoint && \
                            docker compose pull && \
                            docker compose up -d && \
                            docker system prune -f && \
                            echo "Deployment completed!"
                        '
                    """
                }
            }
        }
        
        stage('Health Check') {
            when {
                expression { params.DEPLOY_TO_AWS == true }
            }
            steps {
                echo 'Running health checks...'
                sh """
                    sleep 15
                    curl -f http://${SERVER_IP}:4000/api/lawyers || echo 'Backend check warning'
                    curl -f http://${SERVER_IP}:3000 || echo 'Frontend check warning'
                    echo 'Health checks completed!'
                """
            }
        }
    }
    
    post {
        always {
            echo 'Cleaning up...'
            sh '''
                docker logout || true
            '''
        }
        success {
            echo '✅ Pipeline completed successfully!'
            echo "Images pushed to Docker Hub: https://hub.docker.com/u/${DOCKERHUB_USERNAME}"
            script {
                if (params.DEPLOY_TO_AWS) {
                    echo "🚀 Application deployed to: http://${SERVER_IP}:3000"
                }
            }
        }
        failure {
            echo '❌ Pipeline failed! Check the logs above.'
        }
    }
}
