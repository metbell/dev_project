pipeline{
 agent any
    stages{
        stage('Build Artifact'){
            steps{
                sh "mvn clean package -DskipTests=true"
                //archive 'target/*.jar'
                archiveArtifacts 'target/*.jar'
            }     
            
        }
        stage('Maven test'){
            steps{
                sh "mvn test"
            }

            post{
                always{
                    junit 'target/surefire-reports/*.xml'
                    jacoco execPattern: 'target/jacoco.exec'
                }
            }
        }
        stage('Docker build and push '){
            steps{
             sh 'sudo -i'
              // withDockerRegistry([credentialsId: "docker-hub", url: ""]){
                sh 'printenv'
                sh 'sudo docker build -t metbell/numeric-app:""$GIT_COMMIT"" .'
                //sh 'cat ~/secret.txt | docker login -u metbell --password-stdin'
                sh 'sudo docker push metbell/numeric-app:""$GIT_COMMIT""'
             // }
            }
        }
        stage('K8S Deployment - DEV') {
            steps {
                withKubeConfig([credentialsId: 'kubeconfig']) {
                  sh "sed -i 's#replace#metbell/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
                  sh "kubectl apply -f k8s_deployment_service.yaml"
                }
            }
        }
   }
}
   
 
