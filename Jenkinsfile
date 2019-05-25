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
            when { expresion { env.BRANCH_NAME ==~ /dev.*/ || env.BRANCH_NAME ==~ /PR.*/ || env.BRANCH_NAME ==~ /feat.*/ }}
            steps{
                echo 'Init stage'
                sh 'cd terraform && terraform init -input=false'
            }
        }
         stage("Validate"){
            when { expresion { env.BRANCH_NAME ==~ /dev.*/ || env.BRANCH_NAME ==~ /PR.*/ || env.BRANCH_NAME ==~ /feat.*/ }} 
            steps{
                echo 'Validate stage'
                sh 'cd terraform && terraform validate'
            }
        }
        stage("Plan and Create PR"){
            when { expresion { env.BRANCH_NAME ==~ /dev.*/ || env.BRANCH_NAME ==~ /PR.*/ || env.BRANCH_NAME ==~ /feat.*/ }}
            steps{
                echo 'Plan Stage'
                sh 'cd terraform && terraform plan -out=plan -input=false'
                input(message: "Do you want to create a PR to apply this plan?", ok: 'yes')
            }
        }
        stage("Apply"){
            when { expresion { env.BRANCH_NAME ==~ /dev.*/ || env.BRANCH_NAME ==~ /PR.*/ || env.BRANCH_NAME ==~ /feat.*/ }}
            steps{
                echo 'Apply Stage'
            }
        }
        stage("Destroy"){
            when { expresion { env.BRANCH_NAME ==~ /dev.*/ || env.BRANCH_NAME ==~ /PR.*/ || env.BRANCH_NAME ==~ /feat.*/ }}
            steps{
                echo 'Destroy Stage'
            }
        }
    }
}
