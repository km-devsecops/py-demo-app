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
                    sh "bandit --severity-level high . -r -o bandit.json -f json --exit-zero"
                }
            }
        }
        stage('3rdParty Vulnerabilities'){
            steps {
                script {
                    try {
                        sh "pip-audit -o audit.json  -f json"
                    } catch (Exception e)  {
                        echo 'Exception occurred: ' + e.toString()
                        echo 'Ignoring hard exit from pip-audit'
                    }
                }
            }
        }
        stage('Ivanti Neurons: Upload') {
            steps {
                echo 'Uploading data into RiskSense ..'
            }
        }
        stage('Ivanti Neurons: CheckPoint') {
            steps {
                echo 'Check if all vulnerability scanner data is within thresholds ..'
            }
        }
    }
}