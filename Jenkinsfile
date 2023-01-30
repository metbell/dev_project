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
        stage('Docker build&push '){
            steps{
               withDockerRegistry([credentialsId: "docker-hub", url: ""]){
                sh 'printenv'
                sh 'docker build -t metbell/numeric-app:""$GIT_COMMIT"" .'
                sh 'cat ~/secret.txt | docker login -u metbell --password-stdin'
                sh 'docker push metbell/numeric-app:""$GIT_COMMIT""'
              }
            }
        }
   }
}
   
