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

        stage('Artifact uploader - Nexus'){
            steps{
                nexusArtifactUploader(
                     nexusVersion: 'nexus3',
                     protocol: 'http',
                     nexusUrl: '192.168.1.253:8081',
                     groupId: 'com.devsecops',
                     version: '0.0.1',
                     repository: 'http://192.168.1.253:8081/repository/numeric-release/',
                     credentialsId: 'nexus-repo',
        artifacts: [
            [artifactId: numeric,
             classifier: '',
             file: 'target/numeric-0.0.1.jar',
             type: 'jar']
        ]
     )
                
            }     
            
        }

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
   
 
