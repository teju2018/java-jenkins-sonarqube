
pipeline {
    agent any
    environment {
        IMAGE_NAME = "java-sonarqube"
       
    }
    stages {
        stage("Docker Hub Connection") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', 
                                                  usernameVariable: 'DOCKER_USER', 
                                                  passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    '''
                }
            }
        }

       

        stage('Build & SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') { // Use the name configured in Jenkins settings
                    sh '''
                           mvn clean verify sonar:sonar \
                              -Dsonar.projectKey=java1 \
                              -Dsonar.projectName='java1' \
                              -Dsonar.host.url=http://192.168.2.101:9000 \
                              -Dsonar.token=squ_df8ccbc7419d258f34b097d68cf10ea3711f7230
                    '''
                }
            }
        }

        stage("Quality Gate") {
            steps {
              timeout(time: 10, unit: 'MINUTES') {
                waitForQualityGate abortPipeline: false
              }
            }
          }


        stage("Run Docker Compose") {
            steps {
                sh '''
                docker build -t "${IMAGE_NAME}" .
                '''
            }
        }

        

        stage("Docker Tags & Push (Python App)") {
            steps {
                sh '''
                docker tag ${IMAGE_NAME} xyz673/${IMAGE_NAME}:${BUILD_NUMBER}
                docker push xyz673/${IMAGE_NAME}:${BUILD_NUMBER}

               
                '''
            }
        }

        
        

        
    }
}
