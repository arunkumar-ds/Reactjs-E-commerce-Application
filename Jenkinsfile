pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = "arun0801" 
        DOCKER_CRED_ID  = "docker-hub-credentials"
    }

    stages {
        stage('Checkout') {
            steps {
                // Pulls the code from the branch that triggered the webhook
                checkout scm
            }
        }

        stage('Build & Tag') {
            steps {
                script {
                    // Determine if we are on dev or master/main
                    def branch = env.GIT_BRANCH ?: env.BRANCH_NAME
                    echo "Current Branch detected: ${branch}"

                    if (branch.contains('dev')) {
                        sh "chmod +x build.sh && ./build.sh ${DOCKER_HUB_USER}/dev latest"
                    } else if (branch.contains('master') || branch.contains('main')) {
                        sh "chmod +x build.sh && ./build.sh ${DOCKER_HUB_USER}/prod latest"
                    } else {
                        error "Build stopped: Branch ${branch} is not configured."
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    def branch = env.GIT_BRANCH ?: env.BRANCH_NAME
                    
                    // Uses Jenkins Credentials to log in to Docker Hub automatically
                    docker.withRegistry('', DOCKER_CRED_ID) {
                        if (branch.contains('dev')) {
                            sh "docker push ${DOCKER_HUB_USER}/dev:latest"
                        } else if (branch.contains('master') || branch.contains('main')) {
                            sh "docker push ${DOCKER_HUB_USER}/prod:latest"
                        }
                    }
                }
            }
        }

        stage('Deploy to Server') {
            steps {
                script {
                    def branch = env.GIT_BRANCH ?: env.BRANCH_NAME
                    def targetImage = ""

                    if (branch.contains('dev')) {
                        targetImage = "${DOCKER_HUB_USER}/dev"
                    } else if (branch.contains('master') || branch.contains('main')) {
                        targetImage = "${DOCKER_HUB_USER}/prod"
                    }

                    // Pass the image name to your deploy script
                    sh "chmod +x deploy.sh && ./deploy.sh ${targetImage}"
                }
            }
        }
    }

    post {
        success {
            echo "Deployment successful! Access your app at the EC2 Public IP on Port 80."
        }
        always {
            echo "Cleaning up dangling images to save disk space..."
            // Prevents t2.micro disk from filling up with old image layers
            sh "docker image prune -f"
        }
    }
}
