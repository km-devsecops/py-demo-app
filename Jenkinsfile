node {
    stage('Load Jenkinsfile'){
        checkout([ $class: 'GitSCM', branches: [[name: "develop"]], doGenerateSubmoduleConfigurations: false,
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
