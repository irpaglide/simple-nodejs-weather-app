pipeline {
    agent any

    parameters {
        credentials(name: 'AWS_KEY_ID', description: 'AWS KEYS CREDENTIALS ID', defaultValue: 'jmgarciatest', credentialType: "Username with password", required: true )
        string(name: 'ECR_URL',description: '',defaultValue: 'https://056598417982.dkr.ecr.us-east-2.amazonaws.com')
        string(name: 'ECR_REPO',description: '',defaultValue: 'weatherapp')
        string(name: 'OW_API_KEY',description: '',defaultValue: '560895af60d087983bc18ebaa7fe57a5')
        string(name: 'PORT',description: '',defaultValue: '3000')
    }
    stages {
        stage("Build Prepare") {
            steps {
                script
                  {
                    // calculate GIT lastest commit short-hash
                    gitCommitHash = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
                    shortCommitHash = gitCommitHash.take(7)
                    // calculate a sample version tag
                    VERSION = shortCommitHash
                    // set the build display name
                    currentBuild.displayName = "#${BUILD_ID}-${VERSION}"
                    IMAGE = "$ECR_REPO:$VERSION"
                  }
              }
        }

        stage("Build and Push Image") {
            steps {
              withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${params.AWS_KEY_ID}"]]) {
                script
                  {

                    sh '$(aws ecr get-login --no-include-email --region us-east-2)'

                      docker.withRegistry('$ECR_URL') {

                      def customImage = docker.build("$ECR_REPO:$VERSION", "--build-arg OW_API_KEY=${params.OW_API_KEY} .")
                            /* Push the container to the custom Registry */
                            customImage.push()
                        }


                  }

              }

            }

        }
        stage("Create Deployment (k8s)") {
            steps {
              withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${params.AWS_KEY_ID}"]]) {
                sh '''#!/bin/bash
                  kubectl get deployment/${ECR_REPO}
                  if [ "$?" == "0" ] ; then
                    kubectl set image deployments/${ECR_REPO} ${ECR_REPO}=latest --record=true
                 else
                    kubectl create -f ${ECR_REPO}-deployment.yaml"
                    kubectl expose deployment ${ECR_REPO} --type=LoadBalancer --port=80 --target-port=${PORT} --name=${ECR_REPO}-lb"
                  fi
                '''
              }
            }
        }
    }
}
