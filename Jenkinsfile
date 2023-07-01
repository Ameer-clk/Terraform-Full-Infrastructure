pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Checkout your source code from version control
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                // Set up Maven
                tool 'Maven'
                
                // Run Maven clean and install commands
                sh 'mvn clean install'
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                // Set up SonarQube Scanner
                withSonarQubeEnv('SonarQube') {
                    // Run SonarQube analysis
                    sh 'mvn sonar:sonar'
                }
            }
        }
    }
}
