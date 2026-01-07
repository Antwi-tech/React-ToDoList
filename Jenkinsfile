pipeline {
    agent any

    stages {

        stage("Checkout code") {
            steps {
                git branch: 'main', url: 'https://github.com/Antwi-tech/React-ToDoList.git'
            }
        }

        stage("Build image and push") {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'docker_creds',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh '''
                        docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
                        docker build -t $DOCKER_USERNAME/ci_backend_full_pipeline:v1 -f backend/Dockerfile backend
                        docker build -t $DOCKER_USERNAME/ci_frontend_full_pipeline:v1 -f dive-react-app/Dockerfile dive-react-app
                        docker push $DOCKER_USERNAME/ci_backend_full_pipeline:v1
                        docker push $DOCKER_USERNAME/ci_frontend_full_pipeline:v1
                    '''
                }
            }
        }

        stage("Implement Terraform") {
            steps {
                withAWS(credentials: 'AWS_CREEDS', region: 'us-east-1') {
                    withCredentials([
                        file(credentialsId: 'PUBKEY_FILE',  variable: 'PUBKEY_FILE'),
                        file(credentialsId: 'PRIVKEY_FILE', variable: 'PRIVKEY_FILE')
                    ]) {
                        dir("terraform") {
                            sh '''
                                echo "AWS credentials loaded into environment"

                                cp "$PUBKEY_FILE"  ec2-modules/my_key.pub
                                cp "$PRIVKEY_FILE" ec2-modules/my_key
                                chmod 600 ec2-modules/my_key

                                terraform init
                                terraform apply --auto-approve
                            '''
                        }
                    }
                }
            }
        }

        stage("Connect to EC2 with Ansible") {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'docker_creds',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh '''
                        echo "[app_servers]" > terraform/ec2-modules/ansible_hosts.ini
                        echo "ec2_instance ansible_host=$(terraform -chdir=terraform output -raw public_ip) ansible_user=ubuntu" \
                          >> terraform/ec2-modules/ansible_hosts.ini

                        echo "Inventory:"
                        cat terraform/ec2-modules/ansible_hosts.ini
                    '''

                    ansiblePlaybook(
                        credentialsId: 'ANSPRIV_KEY',
                        disableHostKeyChecking: true,
                        inventory: 'terraform/ec2-modules/ansible_hosts.ini',
                        playbook: 'ansible/deploy.yml',
                        extraVars: [
                            docker_username: "$DOCKER_USERNAME",
                            docker_password: "$DOCKER_PASSWORD"
                        ]
                    )
                }
            }
        }
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


// pipeline {
//     agent any
 
//     stages {
 
//         stage("Checkout code") {
//             steps {
//                 git branch: 'main', url: 'https://github.com/Antwi-tech/React-ToDoList.git'
//             }
//         }
 
//         stage("Build image and push") {
//             steps {
//                 withCredentials([
//                     usernamePassword(credentialsId: 'docker_creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')
//                 ]) {
 
//                     sh '''
//                         docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
//                         docker build -t $DOCKER_USERNAME/ci_backend_full_pipeline:v1 -f backend/Dockerfile backend
//                         docker build -t $DOCKER_USERNAME/ci_frontend_full_pipeline:v1 -f dive-react-app/Dockerfile dive-react-app
//                         docker push $DOCKER_USERNAME/ci_backend_full_pipeline:v1
//                         docker push $DOCKER_USERNAME/ci_frontend_full_pipeline:v1
//                     '''
//                 }
//             }
//         }
//         stage("Implement Terraform") {
            
//             steps {
//                 withAWS(credentials: 'AWS_CREEDS', region: 'us-east-1') {

//                     withCredentials([
//                         file(credentialsId: 'PUBKEY_FILE',  variable: 'PUBKEY_FILE'),
//                         file(credentialsId: 'PRIVKEY_FILE', variable: 'PRIVKEY_FILE')
//                     ]) {

//                         dir("terraform") {
//                             sh """
//                                 echo "AWS credentials loaded into environment"
//                                # Copy SSH keys for EC2 provisioning
//                                  cp "${PUBKEY_FILE}" ec2-modules/my_key.pub
//                                  cp "${PRIVKEY_FILE}" ec2-modules/my_key
//                                  chmod 600 ec2-modules/my_key

//                                 terraform init
//                               #  terraform import aws_key_pair.my_key my_key
//                                 terraform apply --auto-approve
//                             """
//                         }
//                     }
//                 }
//             }
//         }

// //         stage("Implement Terraform") {
// //     steps {
// //         withAWS(credentials: 'AWS_CREEDS', region: 'us-east-1') {
// //             withCredentials([
// //                 file(credentialsId: 'PUBKEY_FILE',  variable: 'PUBKEY_FILE'),
// //                 file(credentialsId: 'PRIVKEY_FILE', variable: 'PRIVKEY_FILE')
// //             ]) {
// //                 dir("terraform") {
// //                     sh '''
// //                         set -eux
                        
// //                         cp "${PUBKEY_FILE}" ec2-modules/my_key.pub
// //                         cp "${PRIVKEY_FILE}" ec2-modules/my_key
// //                         chmod 600 ec2-modules/my_key

// //                         echo "Initialzing terraform"
// //                         terraform init

// //                         echo "Terraform apply"
// //                         terraform apply --auto-approve
// //                     '''
// //                 }
// //             }
// //         }
// //     }
// // }

//         stage("Connect to EC2 with ansible") {
//     steps {
//         sh '''
//         echo "[app_servers]" > terraform/ec2-modules/ansible_hosts.ini
//         echo "ec2_instance \
//         ansible_host=$(terraform -chdir=terraform output -raw public_ip) \
//         ansible_user=ubuntu ansible_ssh_private_key_file=ec2-modules/my_key" \
//         >> terraform/ec2-modules/ansible_hosts.ini
//         '''

//         ansiblePlaybook(
//             credentialsId: 'EC2_KEY',
//             disableHostKeyChecking: true,
//             inventory: 'terraform/ec2-modules/ansible_hosts.ini',
//             playbook: 'ansible/deploy.yml'
//         )
//     }
//  }
// }

// //         stage("Deploy to EC2") {
// //             steps {
// //                 withCredentials([
// //                     sshUserPrivateKey(credentialsId: 'EC2_KEY', keyFileVariable: 'SSH_KEY'),
// //                     string(credentialsId: 'EC2_HOST', variable: 'EC2_HOST'),
// //                     usernamePassword(credentialsId: 'docker_creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')
// //                 ]) {
 
// //                     sh '''
// //     chmod 600 "$SSH_KEY"
 
// //     ssh -o StrictHostKeyChecking=no -i "$SSH_KEY" ubuntu@"$EC2_HOST" << EOF
// //         echo "Connected to EC2"
// //         export DOCKER_USERNAME="$DOCKER_USERNAME"
// //         export DOCKER_PASSWORD="$DOCKER_PASSWORD"
// //         cd /home/ubuntu/React-ToDoList
// //         bash ~/React-ToDoList/deploy.sh
// // EOF
// // '''
 
// //                 }
// //             }
// //         }
// //     }
//   }
//   post {
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


// // pipeline {
// //     agent any
// //     environment{
// //         DOCKER_USERNAME=credentials('DOCKER_USERNAME')
// //         DOCKER_PASSWORD=credentials("DOCKER_PASSWORD")
// //         EC2_HOST=credentials("EC2_HOST")
// //         EC2_KEY=credentials("EC2_KEY")
// //     }
// //     stages{
// //         stage("checkout code"){
// //             steps{
// //                 git branch: 'peter-branch', url: 'https://github.com/bigcephas1/React-ToDoList.git'
// //             }
// //         }
// //         stage('Build image and push'){
// //             steps{
// //                 sh 'chmod 777 buildscript.sh'
// //                 sh './buildscript.sh'
// //                 sh 'docker build -t $DOCKER_USERNAME/ci_backend_full_pipeline:v1 -f ./backend/Dockerfile ./backend'
// //                 sh "docker build -t $DOCKER_USERNAME/ci_frontend_full_pipeline:v1 -f ./dive-react-app/Dockerfile ./dive-react-app"
// //                 sh 'docker push $DOCKER_USERNAME/ci_backend_full_pipeline:v1'
// //                 sh 'docker push $DOCKER_USERNAME/ci_frontend_full_pipeline:v1'
// //             }
// //         }
// //         // stage("Deploy to ec2"){
// //         //     steps{
// //         //         writeFile file: 'deployment_key.pem', text: 'EC2_KEY'
// //         //         sh 'chmod 600 deployment_key.pem'
// //         //         sh """
// //         //         ssh -o StrictHostKeyChecking=no -i 
// //         //         deployment_key.pem ubuntu@${EC2_HOST}'
// //         //         """
// //         //     }
// //         // }
// //     }
// // }



// // pipeline {
// //     agent {
// //       docker {
// //         image "docker:24.0.0"
// //         // args '-u root:root'
// //         args '--privileged -v /var/run/docker.sock:/var/run/docker.sock'
// //          }
// //       }

// //     environment {
// //         DOCKER_USERNAME=credentials('DOCKER_CREDENTIALS')
// //         DOCKER_PASSWORD=credentials('DOCKER_PASSWORD')
// //         EC2_HOST=credentials('EC2_HOST')
// //         EC2_KEY=credentials('EC2_KEY')

// //     }  
 
 
// //     stages {
 
// //         stage('Checkout') {
// //             steps {
// //                 git branch: 'main',
// //                     url: 'https://github.com/Antwi-tech/React-ToDoList.git'
// //             }
// //         }
 
// //         stage('Build an image and push') {
// //             steps {
// //                 sh 'chmod 777 buildscript.sh'
// //                 sh './buildscript.sh'
// //             }
// //         }
 
// //         // stage('Deploy to ec2') {
// //         //     steps {
// //         //         writeFile file: 'deployment-key', text: 'EC2_KEY'
// //         //         sh 'chmod 600 deployment-key.pem'
// //         //         sh """
// //         //         ssh -o StrictHostKeyChecking=no -i deployment-key.pem
// //         //         ubuntu@${EC2_HOST}
// //         // }
 
// //     }
 
// //     post {
// //         always {
// //             cleanWs()
// //         }
// //         success {
// //             emailext(
// //                 subject: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
// //                 body: "The build ${env.BUILD_URL} completed successfully.",
// //                 to: "nanaafuaantwiwaa624@gmail.com"
// //             )
// //         }
// //         failure {
// //             emailext(
// //                 subject: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
// //                 body: "The build ${env.BUILD_URL} failed. Please check the logs.",
// //                 to: "nanaafuaantwiwaa624@gmail.com"
// //             )
// //         }
// //     }
// // }