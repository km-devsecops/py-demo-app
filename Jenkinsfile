pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('SonarQube analysis') {
            steps {
                script {
                    def scannerHome = tool 'SonarQubeScanner47';
                    withSonarQubeEnv('sonar-cloud') {
                        sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=py-demo-app \
                                                             -Dsonar.organization=csw-devsecops-org \
                                                             -Dsonar.python.version=3"
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
