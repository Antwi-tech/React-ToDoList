pipeline {
    agent {
      docker {
        image "docker:24.0.0"
        // args '-u root:root'
        args '--privileged -v /var/run/docker.sock:/var/run/docker.sock'
         }
      }

    environment {
        DOCKER_USERNAME=credentials('DOCKER_CREDENTIALS')
        DOCKER_PASSWORD=credentials('DOCKER_PASSWORD')
        EC2_HOST=credentials('EC2_HOST')
        EC2_KEY=credentials('EC2_KEY')

    }  
 
 
    stages {
 
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Antwi-tech/React-ToDoList.git'
            }
        }
 
        stage('Build an image and push') {
            steps {
                cd scripts/
                sh 'chmod 777 buildscript.sh'
                sh './buildscript.sh'
            }
        }
 
        // stage('Deploy to ec2') {
        //     steps {
        //         writeFile file: 'deployment-key', text: 'EC2_KEY'
        //         sh 'chmod 600 deployment-key.pem'
        //         sh """
        //         ssh -o StrictHostKeyChecking=no -i deployment-key.pem
        //         ubuntu@${EC2_HOST}
        // }
 
    }
 
    post {
        always {
            cleanWs()
        }
        success {
            emailext(
                subject: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "The build ${env.BUILD_URL} completed successfully.",
                to: "nanaafuaantwiwaa624@gmail.com"
            )
        }
        failure {
            emailext(
                subject: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "The build ${env.BUILD_URL} failed. Please check the logs.",
                to: "nanaafuaantwiwaa624@gmail.com"
            )
        }
    }
}