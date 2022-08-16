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

        stage('Security Scans') {
            steps {
                parallel {
                    stage('Sonarqube') {
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
                    stage('ThirdParty_Vulnerabilities'){
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
                }
            }
        }

        stage('Container build and Scan'){
            steps {
                script {
                    try {
                        echo "TODO: Container build and scan .."
                    } catch (Exception e)  {
                        echo 'Exception occurred: ' + e.toString()
                        echo 'Ignoring hard exit from container build/scan'
                    }
                }
            }
        }

        stage('Gather Reports'){
            when {
                expression { env.BRANCH_NAME == 'develop' }
            }
            steps {
                echo "Collecting reports from all scanners .. "
                script {
                    sh "python scripts/make_pip_audit_report.py -s audit.json -o ${env.WORKSPACE}/reports/audit-formatted.json"
                }
            }
        }

        stage('Ivanti Neurons: Upload') {
            when {
                expression { env.BRANCH_NAME == 'develop' }
            }
            steps {
                echo 'Uploading data into RiskSense ..'
            }
        }

        stage('Ivanti Neurons: CheckPoint') {
            when {
                expression { env.BRANCH_NAME == 'develop' }
            }
            steps {
                echo 'Check if all vulnerability scanner data is within thresholds ..'
            }
        }

        stage('Deploy') {
            when {
                expression { env.BRANCH_NAME == 'develop' }
            }
            steps {
                echo 'Deploy the new image and rotate tasks ..'
            }
        }

        stage('Validation Tests') {
            when {
                expression { env.BRANCH_NAME == 'develop' }
            }
            steps {
                echo 'Run validation tests including health checks ..'
            }
        }
    }
}