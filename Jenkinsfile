pipeline {
  agent any
  stages {
    stage('Style Check') {
      steps {
        powershell(script: 'test', returnStatus: true, returnStdout: true)
      }
    }

  }
}