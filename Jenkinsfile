pipeline{
    agent any
    environment {
        TOKEN_OBA = credentials('git-token-OBA')
        LOGIN = sh script:"vault login -method=github token=${TOKEN_OBA}"
        DIGITALOCEAN_TOKEN= sh(script:'vault kv get -field=token workshop/OrlandoBA/digitalocean', returnStdout: true).trim()
    }
    triggers {
        pollSCM('H/5****')
    }
    stages{
        stage("Init"){
            steps{
                echo 'Init stage'
                sh 'cd terraform && terraform init -input=false'
            }
        }
         stage("Validate"){
            steps{
                echo 'Validate stage'
                sh 'cd terraform && terraform validate'
            }
        }
        stage("Plan and Create PR"){
            steps{
                echo 'Plan Stage'
                sh 'cd terraform && terraform plan -out=plan -input=false'
                input(message: "Do you want to create a PR to apply this plan?", ok: 'yes')
            }
        }
        stage("Apply"){
            steps{
                echo 'Apply Stage'
            }
        }
        stage("Destroy"){
            steps{
                echo 'Destroy Stage'
            }
        }
    }
}
