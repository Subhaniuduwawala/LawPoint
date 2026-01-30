pipeline {
    agent any
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKERHUB_USERNAME = 'subhaniuduwawala'
        BACKEND_IMAGE = "${DOCKERHUB_USERNAME}/lawpoint-backend"
        FRONTEND_IMAGE = "${DOCKERHUB_USERNAME}/lawpoint-frontend"
        GIT_COMMIT_SHORT = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
        SSH_CREDENTIALS = credentials('lawpoint-ssh-key')
        SERVER_IP = credentials('lawpoint-server-ip')
    }
    
    parameters {
        booleanParam(name: 'DEPLOY_TO_AWS', defaultValue: false, description: 'Deploy to AWS after building?')
        booleanParam(name: 'USE_ANSIBLE', defaultValue: false, description: 'Use Ansible for deployment?')
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
        
        stage('Deploy with SSH') {
            when {
                expression { params.DEPLOY_TO_AWS == true && params.USE_ANSIBLE == false }
            }
            steps {
                echo 'Deploying to AWS EC2 via SSH...'
                sshagent(credentials: ['lawpoint-ssh-key']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@\${SERVER_IP} '
                            cd /home/ubuntu/lawpoint && \
                            docker-compose pull && \
                            docker-compose up -d && \
                            docker system prune -f
                        '
                    """
                }
            }
        }
        
        stage('Deploy with Ansible') {
            when {
                expression { params.DEPLOY_TO_AWS == true && params.USE_ANSIBLE == true }
            }
            steps {
                echo 'Deploying to AWS EC2 via Ansible...'
                sh """
                    cd ansible
                    echo "[lawpoint_servers]" > inventory.ini
                    echo "\${SERVER_IP} ansible_user=ubuntu ansible_ssh_private_key_file=\${SSH_CREDENTIALS}" >> inventory.ini
                    echo "" >> inventory.ini
                    echo "[lawpoint_servers:vars]" >> inventory.ini
                    echo "ansible_python_interpreter=/usr/bin/python3" >> inventory.ini
                    
                    ansible-playbook -i inventory.ini deploy.yml
                """
            }
        }
        
        stage('Health Check') {
            when {
                expression { params.DEPLOY_TO_AWS == true }
            }
            steps {
                echo 'Running health checks...'
                script {
                    sleep(30)
                    sh """
                        curl -f http://\${SERVER_IP}:4000/api/lawyers || echo 'Backend health check failed'
                        curl -f http://\${SERVER_IP}:3000 || echo 'Frontend health check failed'
                    """
                }
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
        }
        failure {
            echo '❌ Pipeline failed! Check the logs above.'
        }
    }
}
