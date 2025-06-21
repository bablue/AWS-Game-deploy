pipeline {
  agent any

  parameters {
    choice(name: 'ENVIRONMENT', choices: ['dev', 'uat'], description: 'Choose environment to deploy')
  }

  environment {
    PATH = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    TFVARS_FILE = "terraform.tfvars.${params.ENVIRONMENT}"
  }

  stages {
    stage('Verify Terraform') {
      steps {
        sh 'echo $PATH'
        sh 'which terraform'
        sh 'terraform -v'
      }
    }

    stage('Terraform Init') {
      steps {
        dir('infra') {
          sh 'terraform init'
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        dir('infra') {
          sh "terraform plan -var-file=${TFVARS_FILE}"
        }
      }
    }

    stage('Terraform Apply') {
      steps {
        input message: "Apply infrastructure to ${params.ENVIRONMENT}?", ok: "Yes, deploy"
        dir('infra') {
          sh "terraform apply -auto-approve -var-file=${TFVARS_FILE}"
        }
      }
    }
  }
}
