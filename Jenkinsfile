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
   stage('Build') {
      withEnv(["GOROOT=${root}", "PATH+GO=${root}/bin"]) {
        sh 'CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags "-extldflags \'-static\'" -o ./main'
    }     
   }
   stage('Archive') {
      archiveArtifacts "main"
   }

}