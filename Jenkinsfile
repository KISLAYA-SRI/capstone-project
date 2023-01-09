pipeline{
    agent any 

    environment {
        NEXUS_DOCKER_URL="35.209.45.241:8085"
        NEXUS_URL="35.209.45.241:8081"
        IMAGE_NAME="simple-app"
        IMAGE_TAG="${env.BUILD_ID}"
    }

    stages{
        stage('mvn build') {
            steps {
                dir("Api1"){
                    sh 'mvn -B -DskipTest clean package'
                }
            }
        }
    //     stage('mvn test') {
    //         when {
    //            expression {stage == 'unittest'}
    //          }

    //         steps {
    //             sh 'mvn test'
    //             junit 'target/surefire-reports/*.xml'
    //         }
    //     }
    //     stage('checkstyle') {
    //         when {
    //       expression {stage == 'checkstyle'}
    //   }

    //         steps {
    //             sh 'mvn checkstyle:checkstyle'
    //             recordIssues(tools: [checkStyle(pattern: '**/checkstyle-result.xml')])
                
    //         }
    //     }
    //      stage('code coverage') {
    //          when {
    //       expression {stage == 'codecoverage'}
    //   }

    //         steps {
    //             jacoco()
                
    //         }
    //     }
        stage('sonar') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                  	input(id: "sonar", message: "SonarQube", ok: 'OK')
                }
                dir("Api1"){
                    sh 'mvn clean verify sonar:sonar \
                            -Dsonar.projectKey=kislaya \
                            -Dsonar.host.url=http://35.206.100.225:9000 \
                            -Dsonar.login=sqp_6ab0c20b3f0ae2249d921f656dc8930bb7f6fec7' 
                }    
            }
        }
        stage('Jar to Nexus') {
            steps {
                script {
                    
                    dir("Api1"){
                        pom = readMavenPom file: "pom.xml";
                        filesByGlob = findFiles(glob: "target/*.${pom.packaging}");
                        echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
                        artifactPath = filesByGlob[0].path;
                
                        nexusArtifactUploader artifacts: [[artifactId: pom.artifactId, classifier: '', file: artifactPath, type: pom.packaging]], credentialsId: 'nexus', groupId: pom.artifactId, nexusUrl: "${NEXUS_URL}", nexusVersion: 'nexus3', protocol: 'http', repository: 'maven-snapshots', version: pom.version  
                    }
                }
            }
        }
        stage('Docker build and push') {
            steps {
                script{
                    
                    dir("Api1"){
                        withDockerRegistry(credentialsId: 'nexus', url: "http://${NEXUS_DOCKER_URL}") {
                            // sh 'mvn compile jib:build -Djib.allowInsecureRegistries=true -DsendCredentialsOverHttp'
                            sh "mvn compile jib:build -Djib.to.image=${NEXUS_DOCKER_URL}/${IMAGE_NAME}:${IMAGE_TAG} -Djib.allowInsecureRegistries=true -DsendCredentialsOverHttp"
                        }
                    }
                }
            }
        }
        // stage("Ansible"){
        //     steps{
        //         script{
        //             ansiblePlaybook credentialsId: 'jenkins-chat-app', disableHostKeyChecking: true, inventory: 'ansible/dev.inv', playbook: 'ansible/tomcat.yaml'
        //         }
        //     }
        // }
    }
    post{
        always{
            deleteDir()
            //sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
        }
    }
}