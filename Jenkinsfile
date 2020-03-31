pipeline {
    agent any 
    stages {
        stage('Build') { 
            steps {
               docker-compose -f docker-compose-test.yml build runner 
            }
        }
        stage('Test') { 
            steps {
               docker-compose -f docker-compose-test.yml run --rm runner
            }
        }
        stage('Deploy') {
            steps {
                // 
            }
        }
    }
}
