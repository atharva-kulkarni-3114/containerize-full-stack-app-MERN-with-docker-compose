pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                checkout scm
            }
        }
        
        stage('Deploy') {
            steps {
                echo 'Deploying Docker containers...'
                sh 'chmod +x deploy.sh'
                sh './deploy.sh'
            }
        }
        
        stage('Health Check') {
            steps {
                echo 'Running health checks...'
                timeout(time: 5, unit: 'MINUTES') {
                    sh 'chmod +x health-check.sh'
                    sh './health-check.sh'
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check the logs for details.'
        }
    }
}

