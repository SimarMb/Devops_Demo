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
        
        stage ('Build & Package') {
            steps {
                withSonarQubeEnv('SonarQubeScanner') {
                    sh 'mvn sonar:sonar \
                            -Dsonar.projectKey=test:maven \
                            -Dsonar.host.url=http://localhost:9000 \
                            -Dsonar.login=9921a83026c860fb8a2b4ff863f3a9bc786a972a'
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
                        credentialsId: 'nexus3', 
                        groupId: 'test', 
                        nexusUrl: 'localhost:8081', 
                        nexusVersion: 'nexus3', 
                        protocol: 'http', 
                        repository: 'Demo_project', 
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

