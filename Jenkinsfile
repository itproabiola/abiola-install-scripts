pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    stages {
        stage('Checkout Repository') {
            steps {
                checkout scm
            }
        }

        stage('Validate Bash Scripts') {
            steps {
                sh '''
                    set -eu
                    echo "Checking Bash syntax..."

                    find . -type f -name '*.sh' -exec bash -n {} +

                    echo "All Bash scripts passed syntax validation."
                '''
            }
        }

        stage('ShellCheck') {
            steps {
                sh '''
                    set -eu
                    echo "Running ShellCheck..."

                    find . -type f -name '*.sh' -exec shellcheck {} +

                    echo "All ShellCheck checks passed."
                '''
            }
        }
    }

    post {
        success {
            echo 'SUCCESS: All pipeline checks passed.'
        }
        failure {
            echo 'FAILED: Check the console output.'
        }
        always {
            echo 'Pipeline execution completed.'
        }
    }
}
