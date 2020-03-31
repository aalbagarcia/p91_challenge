pipeline {
    agent any
    environment {
        DOCKER_HOST = 'http://localhost:2375'
    }
    stages {
        stage('Build') { 
            steps {
               sh 'docker-compose -f docker-compose-test.yml build runner'
            }
        }
        stage('Test') { 
            steps {
                sh 'mkdir test/reports'
                sh 'chmod 777 test/reports'
                sh 'docker-compose -f docker-compose-test.yml run --rm runner'
                junit 'test/reports/*.xml'
            }
        }
    }
    post {
        always {
            sh "docker-compose down -v"
            sh 'rm -rf test/reports'
        }
    }
}
