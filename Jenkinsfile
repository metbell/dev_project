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
<<<<<<< HEAD

        stage('Copying Artifact'){
            steps{
                echo '################-_-copying-_-##############'
                sh  'scp ""$PWD""/target/*.jar 192.168.1.253: ~/opt/app'
                
            }     
            
        }

=======
>>>>>>> e6c72dff6fc5551dcafda17e5085d62ac17607e9
        stage('Sonarqube - SAST'){
            steps{
                sh "mvn sonar:sonar -Dsonar.projectKey=numeric-application -Dsonar.host.url=http://192.168.1.253:9000  -Dsonar.login=3cc407241a46bf3c760fe683c9d8ae6001f92563"
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
   
 
