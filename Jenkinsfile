node {
   def commit_id
   def root = tool name: 'Go 1.12', type: 'go'
   stage('Preparation') {
     checkout scm
     sh "git rev-parse --short HEAD > .git/commit-id"
     commit_id = readFile('.git/commit-id').trim()
   }                
   stage{
      withEnv(["GOROOT=${root}", "PATH+GO=${root}/bin"]) {
        sh 'go test'
    }     
   }           
   stage('docker build/push') {            
     docker.withRegistry('https://index.docker.io/v1/', 'dockerhub') {
       def app = docker.build("nightdesoul/golang_example:${commit_id}", '.').push()
     }                                     
   } 
}