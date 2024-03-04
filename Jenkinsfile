pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = 'kanwarsaad'
        APP_NAME = 'ecommerce'
        IMAGE_TAG = "${BUILD_NUMBER}"
        IMAGE_NAME = "${DOCKERHUB_USERNAME}/${APP_NAME}"
        REGISTRY_CREDS = 'dockerhub'
    }

    stages {
        stage('Cleanup Workspace') {
            steps {
                script {
                    cleanWs()
                }
            }
        }
        
        stage('Checkout Scm') {
            steps {
                script {
                    git credentialsId: 'github',
                        url: 'https://github.com/kanwarsaadali/Shoes-Ecommerce.git',
                        branch: 'main'
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    docker_image = docker.build(IMAGE_NAME)
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', REGISTRY_CREDS) {
                        docker_image.push(BUILD_NUMBER)
                        docker_image.push('latest')
                    }
                }
            }
        }
        
        stage('Delete Docker Images') {
            steps {
                script {
                    sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker rmi ${IMAGE_NAME}:latest"
                }
            }
        }
        
        stage('Updating Kubernetes Deployment file') {
            steps {
                script {
                    sh """
                      cat deployment.yml
                      sed -i "s/${APP_NAME}.*/${APP_NAME}:${IMAGE_TAG}/g" deployment.yml
                      cat deployment.yml
                    """
                }
            }
        }
        
        stage('Push The Changed Deployment File To Git') {
            steps {
                script {
                    sh """
                      git config --global user.name "kanwarsaad"
                      git config --global user.email "kanwarsaad@gmail.com"
                      git add deployment.yml
                      git commit -m "update the deployment file"
                    """
                    withCredentials([gitUsernamePassword(credentialsId: 'github', gitToolName: 'Default')]) {
                    sh "git push https://github.com/kanwarsaadali/Shoes-Ecommerce.git main" 
}
                    
                }
            }
        }
    }
}