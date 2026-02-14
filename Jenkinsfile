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
                branch 'main'
            }
            steps {
                echo 'Deploying to AWS EC2...'
                withCredentials([file(credentialsId: 'lawpoint-ssh-key', variable: 'SSH_KEY_FILE')]) {
                    sh """
                        echo 'Connecting to AWS EC2 instance...'
                        ssh -o StrictHostKeyChecking=no -i \${SSH_KEY_FILE} ubuntu@${SERVER_IP} '
                            echo "Connected to \$(hostname)"
                            echo "Current user: \$(whoami)"
                            
                            if [ ! -d "/home/ubuntu/lawpoint" ]; then
                                echo "Creating lawpoint directory..."
                                mkdir -p /home/ubuntu/lawpoint
                            fi
                            
                            cd /home/ubuntu/lawpoint || exit 1
                            echo "Working directory: \$(pwd)"
                            
                            echo "Pulling latest Docker images..."
                            docker compose pull || exit 1
                            
                            echo "Starting services..."
                            docker compose up -d || exit 1
                            
                            echo "Cleaning up unused Docker resources..."
                            docker system prune -f
                            
                            echo "✅ Deployment completed successfully!"
                            docker compose ps
                        '
                    """
                }
            }
        }
        
        stage('Health Check') {
            when {
                branch 'main'
            }
            steps {
                echo 'Running health checks...'
                sh """
                    sleep 15
                    echo 'Testing backend health endpoint...'
                    curl -f http://${SERVER_IP}:4000/api/health || { echo 'Backend health check FAILED'; exit 1; }
                    echo 'Backend is healthy!'
                    
                    echo 'Testing frontend...'
                    curl -f http://${SERVER_IP}:3000 || { echo 'Frontend check FAILED'; exit 1; }
                    echo 'Frontend is accessible!'
                    
                    echo 'All health checks passed!'
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
            echo ' Pipeline completed successfully!'
            echo "Images pushed to Docker Hub: https://hub.docker.com/u/${DOCKERHUB_USERNAME}"
            echo "🚀 Application deployed to: http://${SERVER_IP}:3000"
            echo "📊 Backend API: http://${SERVER_IP}:4000"
        }
        failure {
            echo ' Pipeline failed! Check the logs above.'
        }
    }
}
