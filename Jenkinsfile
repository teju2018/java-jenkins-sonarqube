
pipeline {
    agent any
    environment {
        IMAGE_NAME = "java-sonarqube3"
       
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
                              -Dsonar.token=squ_7db09babe0b31e3a7e9c9e871fc520665607a155
                    '''
                }
            }
        }
        stage("Quality Gate") {
            steps {
                timeout(time: 10, unit: 'MINUTES') { // Wait max 10 mins
                    script {
                        def qualityGate = waitForQualityGate()
                        if (qualityGate.status != 'OK') {
                            error " Quality Gate Failed! Fix issues in SonarQube."
                        } else {
                            echo " Quality Gate Passed!"
                        }
                    }
                }
            }
        }
        /*
        stage("Quality Gate") {
            steps {
              timeout(time: 10, unit: 'MINUTES') {
                waitForQualityGate abortPipeline: false
              }
            }
          }

*/
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
