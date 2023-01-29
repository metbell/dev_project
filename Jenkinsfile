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
        stage{
            steps{
              docker.withRegistry([credentialsId: "docker-hub", url: ""]){
                printenv
                sh 'docker build -t metbell/numeric-app:""$GIT_COMMIT"" .'
                sh 'docker push metbell/numeric-app:""$GIT_COMMIT""'
              }
            }
        }
   }
}
   
