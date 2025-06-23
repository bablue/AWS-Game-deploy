pipeline {
  agent any

  parameters {
    choice(name: 'DEPLOY_TYPE', choices: ['infra', 'ui'], description: 'Choose what to deploy')
    choice(name: 'ENVIRONMENT',  choices: ['dev', 'uat'], description: 'Choose environment to deploy')
  }

  environment {
    PATH = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    TFVARS_FILE = "terraform.tfvars.${params.ENVIRONMENT}"
    # S3_BUCKET_NAME is set after infra apply, or you can hardcode mapping if needed
  }


  stages {
    stage('Verify Terraform') {
      when { expression { params.DEPLOY_TYPE == 'infra' } }
      steps {
        sh 'echo $PATH'
        sh 'which terraform'
        sh 'terraform -v'
      }
    }

    stage('Terraform Init') {
      when { expression { params.DEPLOY_TYPE == 'infra' } }
      steps {
        dir('infra') {
          sh 'terraform init'
        }
      }
    }

    stage('Terraform Plan') {
      when { expression { params.DEPLOY_TYPE == 'infra' } }
      steps {
        dir('infra') {
          sh "terraform plan -var-file=${TFVARS_FILE}"
        }
      }
    }

    stage('Terraform Apply') {
      when { expression { params.DEPLOY_TYPE == 'infra' } }
      steps {
        input message: "Apply infrastructure to ${params.ENVIRONMENT}?", ok: "Yes, deploy"
        dir('infra') {
          sh "terraform apply -auto-approve -var-file=${TFVARS_FILE}"
        }
      }
    }

    stage('Build UI') {
      when { expression { params.DEPLOY_TYPE == 'ui' } }
      steps {
        dir('game-ui') {
          sh 'npm install'
          sh 'npm run build'
        }
      }
    }

    stage('Deploy UI to S3') {
      when { expression { params.DEPLOY_TYPE == 'ui' } }
      steps {
        script {
          // Map environment to bucket name (or fetch dynamically if needed)
          def bucket = params.ENVIRONMENT == 'dev' ? 'game-bucket-bhaskar-dev' : 'game-bucket-bhaskar-uat'
          dir('game-ui') {
            sh "aws s3 sync build/ s3://${bucket}/ --delete"
          }
        }
      }
    }
  }
}