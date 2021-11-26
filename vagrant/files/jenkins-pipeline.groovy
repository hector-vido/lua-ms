pipeline {
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: docker
            image: docker:stable-dind
            tty: true
            securityContext:
                privileged: true
        '''
    }
  }
  environment {
    IMG = 'hectorvido/lua-app'
    DOCKER = credentials('docker')
  }
  stages {
    stage('Clone') {
      steps {
        sh 'git clone http://gitea.172-27-11-10.nip.io/devops/lua-app'
      }
    }
    stage('Build') {
      steps {
        container('docker') {
          sh 'docker build -t $IMG -f lua-app/docker/Dockerfile lua-app'
        }
      }
    }
    stage('Test') {
      steps {
        container('docker') {
          sh 'apk add docker-compose'
          sh 'docker-compose -f docker/docker-compose.yml up -d'
          sh 'sleep 30'
          sh 'curl localhost:8080'
        }
      }
    }
    stage('Delivery') {
      steps {
        container('docker') {
          sh 'docker login -u $DOCKER_USR -p $DOCKER_PSW'
          sh 'docker push $IMG'
        }
      }
    }
  }
  post {
    always {
      echo 'Fim'
    }
  }
}
