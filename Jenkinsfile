pipeline{
 agent any
    stages{
        stage('Build Artifact'){
            steps{
                sh "mvn clean package -Dskiptest=true"
                archive 'target/*.jar'
            }     
            
        }
   }
}
   