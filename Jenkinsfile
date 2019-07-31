node {
   def commit_id
   def root = tool name: 'golang', type: 'go'
   stage('Preparation') {
     checkout scm
     sh "git rev-parse --short HEAD > .git/commit-id"
     commit_id = readFile('.git/commit-id').trim()
   }                
   stage('Test') {
      withEnv(["GOROOT=${root}", "PATH+GO=${root}/bin"]) {
        sh 'go test'
    }     
   }
   stage('sonar-scanner') {
      def sonarqubeScannerHome = tool name: 'sonar', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
      withCredentials([string(credentialsId: 'sonar', variable: 'sonarLogin')]) {
        sh "${sonarqubeScannerHome}/bin/sonar-scanner -e -Dsonar.host.url=http://sonarqube:9000 -Dsonar.login=${sonarLogin} -Dsonar.projectName=go-example -Dsonar.projectVersion=${env.BUILD_NUMBER} -Dsonar.projectKey=GO -Dsonar.sources=. -Dsonar.language=go"
      }
   }
   stage('snyk'){
     sh 'go env'
     withEnv(["GOROOT=${root}", "PATH+GO=${root}/bin", "GOPATH=${JENKINS_HOME}/jobs/${JOB_NAME}/builds/${BUILD_ID}"]) {
        snykSecurity(
          snykInstallation: 'snyk',
          failOnIssues: 'false',
          snykTokenId: 'snyk'
        )
     }
   }
   stage('docker build/push') {            
     docker.withRegistry('https://index.docker.io/v1/', 'dockerhub') {
       def app = docker.build("nightdesoul/golang_example:${commit_id}", '.').push()
     }                                     
   } 
}