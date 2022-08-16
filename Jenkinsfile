node {
    stage('Load Jenkinsfile'){
        checkout([ $class: 'GitSCM', branches: [[name: "feature/event-streaming-multibranch"]], doGenerateSubmoduleConfigurations: false,
                   extensions: [[ $class: 'RelativeTargetDirectory', relativeTargetDir: 'pipeline-scripts']],
                   submoduleCfg: [],
                   userRemoteConfigs: [[ credentialsId: 'github-integration',
                                         url: 'https://github.com/km-devsecops/py-demo-app.git']]
                 ])

        if (env.BRANCH_NAME == 'develop') {
            jenkinsfile = load 'pipeline-scripts/Jenkinsfile.prod'
        }
        else {
            jenkinsfile = load 'pipeline-scripts/Jenkinsfile.default'
        }
    }
}
