pipeline {
    agent any

    tools {
        jdk 'JDK19'
    }

    environment {
        JAVA_HOME = 'C:\\Program Files\\Java\\jdk-19'
        DOCKER_TAG = getVersion().trim()
    }

    stages {
        stage('Verify Git') {
            steps {
                sh 'git --version'
            }
        }

        stage('Clone Stage') {
            steps {
                git branch: 'main', url: 'https://github.com/abdellahdhahri/Pipeline_angular.git'
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    echo "Docker Tag: ${env.DOCKER_TAG}"
                }
                sh "docker build -t abdou1122/image_name:${env.DOCKER_TAG} ."
            }
        }

        stage('DockerHub Push') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub', variable: 'dockerHubPwd')]) {
                    bat 'docker login -u abdou1122 -p %dockerHubPwd%'
                }
                sh "docker push abdou1122/image_name:${env.DOCKER_TAG}"
            }
        }

        stage('Deploy') {
            steps {
                sshagent(credentials: ['Vagrant_ssh']) {
                    sh "ssh user@192.168.182.108"
                    sh "ssh user@192.168.182.108 'sudo docker run abdou1122/image_name:${env.DOCKER_TAG}'"
                }
            }
        }
    }
}

def getVersion() {
    def version = sh returnStdout: true, script: 'git rev-parse --short HEAD'
    echo "Git Version: ${version.trim()}"
    return version
}
