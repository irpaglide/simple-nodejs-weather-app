pipeline {
    agent any

    parameters {
        credentials(name: 'AWS_KEY_ID', description: 'AWS KEYS CREDENTIALS ID', defaultValue: 'jmgarciatest', credentialType: "Username with password", required: true )
        string(name: 'ECR_URL',description: '',defaultValue: '056598417982.dkr.ecr.us-east-2.amazonaws.com')
        string(name: 'ECR_REPO',description: '',defaultValue: 'weatherapp')

    }
    stages {
        stage("Build Image") {
            steps {
              withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${params.AWS_KEY_ID}"]]) {

                sh '$(aws ecr get-login --no-include-email --region us-east-2)'
                sh 'docker build -t ${params.ECR_REPO} .'
                sh 'docker tag ${params.ECR_REPO}:latest ${params.ECR_URL}/${params.ECR_REPO}:latest'
                sh 'docker push ${params.ECR_URL}/${params.ECR_REPO}:latest'
              }
            }
        }
    }
}
