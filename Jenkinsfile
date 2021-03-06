pipeline{
   environment {
      registry = "simaromana/devops_demo"
      registryCredential = 'dockerhub-pwd'
      dockerImage = ''
   }
   
   agent any
   stages{
   
        stage ('Compile Stage') {

            steps {
                withMaven(maven : 'maven_3_6_3') {
                    sh 'mvn clean install package'
                }
            }
        }

        stage ('Testing Stage') {

            steps {
                withMaven(maven : 'maven_3_6_3') {
                    sh 'mvn test'
                }
            }
        }
      
         stage ('Deployment Stage') {
            steps {
                withMaven(maven : 'maven_3_6_3') {
                    nexusArtifactUploader artifacts: [
                        [
                            artifactId: 'maven', classifier: '', 
                            file: 'target/maven-0.0.1.jar', type: 'jar'
                        ]
                    ],
                        credentialsId: 'nexus', 
                        groupId: 'test', 
                        nexusUrl: 'localhost:8081', 
                        nexusVersion: 'nexus3', 
                        protocol: 'http', 
                        repository: 'Devops_Demo', 
                        version: '0.0.1'
                }
            }
        }
       stage('Building our image') {
         steps{
            script {
               dockerImage = docker.build registry + ":$BUILD_NUMBER"
            }
         }
      }
      stage('Deploy our image') {
         steps{
            script {
               docker.withRegistry( '', registryCredential ) {
               dockerImage.push()
               }
            }
         }
      }
      stage('Cleaning up') {
         steps{
            sh "docker rmi $registry:$BUILD_NUMBER"
         }
      }
   }
}

