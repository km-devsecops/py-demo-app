pipeline {
    agent {
       label "securin"
    }

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
        stage('Code Vulnerabilities'){
            steps {
                script {
                    sh "bandit --security-level high . -r -o bandit.json -f json"
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
