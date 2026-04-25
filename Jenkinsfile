pipeline {
  agent any

  stages {

    stage('Build Artifact - Maven') {
      steps {
        sh "mvn clean package -DskipTests=true"
        archive 'target/*.jar'
      }
    }

    stage('Unit test') {
      steps {
        sh "mvn test"
      }
      post {
        always {
          junit 'target/surefire-reports/*.xml'
          jacoco execPattern: 'target/jacoco.exec'
        }
      }
    }

    stage('Docker Build and Push') {
      steps {
        withDockerRegistry([credentialsId: "docker-hub", url: ""]) {
          sh 'printenv'
          sh 'sudo docker build -t arielmoi/devsecops-course:latest .'
          sh 'docker push arielmoi/devsecops-course:latest'
        }
      }
    }

  stage('K8S Deployment - Dev') {
      steps {
        "Deployment": {
          withKubeConfig([credentialsId: 'kubeconfig']) {
            sh "sed -i 's#replace#arielmoi/devsecops-course:latest #g' k8s-deployment_service.yaml"
            sh "kubectl apply -f k8s-deployment_service.yaml"
          }
        }
      }
    }
  } 
}