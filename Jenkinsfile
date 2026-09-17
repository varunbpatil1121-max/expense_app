pipeline {
    agent any

    stages {
        stage('Environment Debug') {
            steps {
                sh 'echo FLUTTER_HOME=$FLUTTER_HOME'
                sh 'echo PATH=$PATH'
                sh 'whoami'
                sh 'ls -l ${FLUTTER_HOME}/bin/'
                sh 'which flutter'
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-token-id',
                    url: 'https://github.com/varunbpatil1121-max/expense_app.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'git config --global --add safe.directory /home/ubuntu/flutter'
                sh 'flutter pub get'
            }
        }

        stage('Build APK') {
            steps {
                sh 'flutter build apk --release'
            }
        }
    }

    post {
        success {
            archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/app-release.apk', allowEmptyArchive: false
        }
    }
}