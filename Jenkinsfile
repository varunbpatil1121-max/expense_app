pipeline {
    agent any

    environment {
        FLUTTER_HOME = '/opt/flutter'
        ANDROID_HOME = '/opt/android-sdk'
        PATH = "/opt/flutter/bin:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
        HOME = '/var/lib/jenkins'
        CI = 'true'
        BOT = 'true'
        PUB_ENVIRONMENT = 'bot.jenkins'
        FLUTTER_SUPPRESS_ANALYTICS = 'true'
    }

    stages {
        stage('Checkout Repository') {
            steps {
                cleanWs()
                git branch: 'main',
                    url: 'https://github.com/varunbpatil1121-max/expense_app.git'
            }
        }

        stage('Get Dependencies') {
            steps {
                echo 'Fetching pub packages...'
                sh 'flutter pub get'
            }
        }

        stage('Build APK') {
            steps {
                echo 'Building release APK...'
                sh 'flutter build apk --release'
            }
        }
    }

    post {
        success {
            archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/app-release.apk', allowEmptyArchive: false
        }
        failure {
            echo 'Pipeline failed. Check console output for details.'
        }
    }
}
