pipeline {
  
  environment {
    /*
    IMPORTANT!!! - Set the values for the following variables to match your environment.
    
    Note:  You must set up Jenkins credentials for the CONTAINER_REGISTRY_CREDENTIALS, SMART_CHECK_CREDENTIALS and KUBE_CONFIG variables.
    
    */
    GIT_REPO =                       "https://github.com/awayleft/jenkins-flask-tutorial.git"
    DOCKER_IMAGE_NAME =              "awayleft/flask-docker"
    CONTAINER_REGISTRY =             "registry.hub.docker.com"
    CONTAINER_REGISTRY_CREDENTIALS = "mr-jenkins"
    SMART_CHECK_HOSTNAME =           "a123ef54471b911e9b43516a099d36c6-285179146.us-east-1.elb.amazonaws.com"
    SMART_CHECK_CREDENTIALS =        "smart-check-jenkins-user"
    KUBE_CONFIG =                    "kubeconfig"
    KUBE_YML_FILE_IN_GIT_REPO =      "flask-docker-kube.yml"
  }

  agent any
  stages {
    stage("Cloning Git Repo") {
      steps {
        git "$GIT_REPO"
      }
    }

    stage("Building image") {
      steps{
        script {
          dockerImage = docker.build('$DOCKER_IMAGE_NAME:$BUILD_NUMBER')
        }
      }
    }

    stage("Stage Image") {
      steps{
        script {
          docker.withRegistry('https://$CONTAINER_REGISTRY', CONTAINER_REGISTRY_CREDENTIALS ) {
            dockerImage.push()
          }
        }
      }
    }

    stage("Smart Check Scan") {
        steps {
            withCredentials([
                usernamePassword([
                    credentialsId: CONTAINER_REGISTRY_CREDENTIALS,
                    usernameVariable: "USER",
                    passwordVariable: "PASSWORD",
                ])             
            ]){            
                smartcheckScan([
                    imageName: "$CONTAINER_REGISTRY/$DOCKER_IMAGE_NAME:$BUILD_NUMBER",
                    smartcheckHost: "$SMART_CHECK_HOSTNAME",
                    insecureSkipTLSVerify: true,
                    smartcheckCredentialsId: SMART_CHECK_CREDENTIALS,
                    imagePullAuth: new groovy.json.JsonBuilder([
                        username: USER,
                        password: PASSWORD,
                        ]).toString(),
                    ])
                }
            }
        }
        

    stage ("Deploy to Cluster") {
      steps{
        //input 'Deploy to Kubernetes?'
        //milestone(1)
        kubernetesDeploy(
            kubeconfigId: KUBE_CONFIG,
            configs: KUBE_YML_FILE_IN_GIT_REPO,
            enableConfigSubstitution: true
        )
      }
    }
  }
}


/* this
   is a
   multi-line comment */

// this is a single line comment
