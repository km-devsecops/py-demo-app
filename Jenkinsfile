node {
    stage('Load Jenkinsfile'){
        if (env.BRANCH_NAME == 'develop') {
            jenkinsfile = load 'Jenkinsfile.prod'
        }
        else {
            jenkinsfile = load 'Jenkinsfile.default'
        }
    }
}
