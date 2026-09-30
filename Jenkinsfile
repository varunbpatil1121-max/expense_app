pipeline {
    agent any

    environment {
        // Paths for the Jenkins agent running on the Mac
        FLUTTER_HOME = '/Users/varunpatil/develop/flutter'
        ANDROID_HOME = '/Users/varunpatil/Library/Android/sdk'
        JAVA_HOME = '/Applications/Android Studio.app/Contents/jbr/Contents/Home'
        PATH = "/Users/varunpatil/develop/flutter/bin:/Users/varunpatil/Library/Android/sdk/cmdline-tools/latest/bin:/Users/varunpatil/Library/Android/sdk/platform-tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
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

        stage('Build AAB and APK') {
            steps {
                echo 'Building release AAB and APK...'
                withCredentials([
                    file(credentialsId: 'expense-app-keystore', variable: 'KEYSTORE_FILE'),
                    string(credentialsId: 'expense-app-store-password', variable: 'STORE_PASSWORD'),
                    string(credentialsId: 'expense-app-key-password', variable: 'KEY_PASSWORD')
                ]) {
                    // Write key.properties for release signing (it is gitignored)
                    sh '''
                        cat > android/key.properties <<EOF
storePassword=$STORE_PASSWORD
keyPassword=$KEY_PASSWORD
keyAlias=expense_app_upload
storeFile=$KEYSTORE_FILE
EOF
                        flutter build appbundle --release
                        flutter build apk --release
                        rm -f android/key.properties
                    '''
                }
            }
        }
    }

    post {
        success {
            archiveArtifacts artifacts: 'build/app/outputs/bundle/release/app-release.aab, build/app/outputs/flutter-apk/app-release.apk', allowEmptyArchive: false
        }
        failure {
            echo 'Pipeline failed. Check console output for details.'
        }
    }
}
