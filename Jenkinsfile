pipeline {
    agent any
    environment{
        DOCKER_USERNAME=credentials('DOCKER_USERNAME')
        DOCKER_PASSWORD=credentials("DOCKER_PASSWORD")
        EC2_HOST=credentials("EC2_HOST")
        EC2_KEY=credentials("EC2_KEY")
    }
    stages{
        stage("checkout code"){
            steps{
                git branch: 'peter-branch', url: 'https://github.com/bigcephas1/React-ToDoList.git'
            }
        }
        stage('Build image and push'){
            steps{
                sh 'chmod 777 buildscript.sh'
                sh './buildscript.sh'
                sh 'docker build -t $DOCKER_USERNAME/ci_backend_full_pipeline:v1 ./backend/Dockerfile'
                sh "docker build -t $DOCKER_USERNAME/ci_frontend_full_pipeline:v1 ./dive-react-app/Dockerfile"
                sh 'docker push $DOCKER_USERNAME/ci_backend_full_pipeline:v1'
                sh 'docker push $DOCKER_USERNAME/ci_frontend_full_pipeline:v1'
            }
        }
        // stage("Deploy to ec2"){
        //     steps{
        //         writeFile file: 'deployment_key.pem', text: 'EC2_KEY'
        //         sh 'chmod 600 deployment_key.pem'
        //         sh """
        //         ssh -o StrictHostKeyChecking=no -i 
        //         deployment_key.pem ubuntu@${EC2_HOST}'
        //         """
        //     }
        // }
    }
}



// pipeline {
//     agent {
//       docker {
//         image "docker:24.0.0"
//         // args '-u root:root'
//         args '--privileged -v /var/run/docker.sock:/var/run/docker.sock'
//          }
//       }

//     environment {
//         DOCKER_USERNAME=credentials('DOCKER_CREDENTIALS')
//         DOCKER_PASSWORD=credentials('DOCKER_PASSWORD')
//         EC2_HOST=credentials('EC2_HOST')
//         EC2_KEY=credentials('EC2_KEY')

//     }  
 
 
//     stages {
 
//         stage('Checkout') {
//             steps {
//                 git branch: 'main',
//                     url: 'https://github.com/Antwi-tech/React-ToDoList.git'
//             }
//         }
 
//         stage('Build an image and push') {
//             steps {
//                 sh 'chmod 777 buildscript.sh'
//                 sh './buildscript.sh'
//             }
//         }
 
//         // stage('Deploy to ec2') {
//         //     steps {
//         //         writeFile file: 'deployment-key', text: 'EC2_KEY'
//         //         sh 'chmod 600 deployment-key.pem'
//         //         sh """
//         //         ssh -o StrictHostKeyChecking=no -i deployment-key.pem
//         //         ubuntu@${EC2_HOST}
//         // }
 
//     }
 
//     post {
//         always {
//             cleanWs()
//         }
//         success {
//             emailext(
//                 subject: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
//                 body: "The build ${env.BUILD_URL} completed successfully.",
//                 to: "nanaafuaantwiwaa624@gmail.com"
//             )
//         }
//         failure {
//             emailext(
//                 subject: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
//                 body: "The build ${env.BUILD_URL} failed. Please check the logs.",
//                 to: "nanaafuaantwiwaa624@gmail.com"
//             )
//         }
//     }
// }


// // pipeline {
// //     agent any

// //     stages {
// //         stage('Checkout') {
// //             steps { checkout scm }
// //         }

// //         stage('Build') {
// //             agent {
// //                 docker {
// //                     image 'docker:24.0.0'
// //                     args '--privileged -v /var/run/docker.sock:/var/run/docker.sock'
// //                 }
// //             }
// //             steps {
// //                 sh 'chmod +x scripts/buildscript.sh'
// //                 sh './scripts/buildscript.sh'
// //             }
// //         }
// //     }
// // }
