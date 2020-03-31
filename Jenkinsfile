pipeline {
    agent any
    environment {
        // Do not use http://localhost:2375
        // https://github.com/docker/compose/issues/6293#issuecomment-432326127
        DOCKER_HOST = 'localhost:2375'
    }
    stages {
        stage('Build') { 
            steps {
               sh 'docker-compose -f docker-compose-test.yml build runner'
            }
        }
        stage('Test') { 
            steps {
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
