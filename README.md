# github-actions-ec2-infrastructure-terraform
deployment of Aws ec2 infrastructure with terraform using github-actions to automate the cicd process workflow


# Project Title: Github Actions Ec2 Infrastructure Provsioning with Terraform
Deployment of Aws ec2 infrastructure with terraform using github-actions to automate the cicd process workflowThe project entails creating two ec2 instances and echa server will house nginx webser and apapce2 webser respctively.The project also have options for user to approve teraform deployment by choosing apply or  to destroy the resopurces created as the case may be 

#### Project overview

1.IAM user Setup: create an IAM user with administrative access and generate secret key and access key for that user.

2.Github: Create the project in github and clone to your root directory in your local terminal 

4.Github Configuration: We are pushing our codes to github so it makes sense if 

other activities will be happening on the github hosted runner itself. We can

 specify which operating system we are connecting to in aws if its ubutu or 
  amazon linux etc

5.Create terraform files - create terraform files neccessary for the provisioning of our resources

6. Create backend.tf files to configure and store terraform statefiles.



<img width="792" height="808" alt="Image" src="https://github.com/user-attachments/assets/a09b95e8-9358-4792-b8bd-60b3e392297e" />

#### Prerequisites:

Before starting the project, ensure you have the following prerequisites:

-An AWS account with the necessary permissions to create resources.

-AWS CLI installed on your local machine.

-Basic familiarity with  Docker and DevOps principles.

-Vscode - code editor installed locally on your machine.

- GitHub - a repository for your project code

https://github.com/clement2019/github-actions-ec2-infrastructure-terraform.git


### Project Workflow
============
#### STAGE 1
==============
#### step 1: Create the project in github and Clone it into yourproject root folder
cd githubactions-aws-ec2-terraform-jenkins
 
 #### Create the project gihubactions pipeline

#### creating the .github/workflows/gihubactions-infra.yml

touch .github folder 
cd .github
cd workflows
touch gihubactions-infra.yml


<img width="1540" height="1258" alt="Image" src="https://github.com/user-attachments/assets/592a5e3e-878e-448f-bcbe-80c2aa7a4519" />

<img width="1556" height="1276" alt="Image" src="https://github.com/user-attachments/assets/0b3671f4-48ed-418c-84aa-6761425ddc9a" />

name: Automate EC2 Infrastructure Provisioning

on:
  workflow_dispatch:
    inputs:
      terraform_action:
        type: choice
        description: select terraform action
        options:
        - apply
        - destroy
        required: true
  push:
    branches:
      - main
      - master
  pull_request:
    branches:
      - main
      - master

permissions:
      id-token: write # for aws oidc connection
      contents: read   # for actions/checkout
      pull-requests: write # for GitHub bot to comment PR
env:
  TF_LOG: INFO
  AWS_REGION: ${{ secrets.AWS_REGION }}
  AWS_ACCESS_KEY: ${{ secrets.AWSACCESSKEY }}
  AWS_SECRET_ACCESS_KEY: ${{ secrets.AWSSECRETACCESSKEY }}
  role-session-name: GitHub-OIDC-TERRAFORM      

jobs:
  deploy:
    name: Terraform
    runs-on: ubuntu-latest
    defaults:
      run:
        shell: bash
        working-directory: .
    steps:

    - name: Checkout Repo
      uses: actions/checkout@v1

   

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v2
      with:
        
        terraform_version: 1.5.5

    - name: Terraform fmt
      id: fmt
      run: terraform fmt

    - name: Terraform Init
      id: init
      env:
        AWS_BUCKET_NAME: ${{ secrets.AWS_BUCKET_NAME }}
        AWS_BUCKET_KEY_NAME: ${{ secrets.AWS_BUCKET_KEY_NAME }}
      run: |
        rm -rf .terraform
        terraform init 
        
    - name: Terraform Validate
      id: validate
      run: terraform validate -no-color 

    - name: Terraform Plan
      id: plan
      run: terraform plan -no-color

    - name: Terraform Apply
      id: apply 
      if: ${{ github.event.inputs.terraform_action == 'apply' }}
      run: terraform apply -auto-approve
      
    - name: Terraform destroy
      id: destroy 
      if: ${{ github.event.inputs.terraform_action == 'destroy' }}
      run: terraform destroy -auto-approve
      #if: github.ref == 'refs/heads/main' && github.event_name == 'push'
#### step 2: Set up Aws credentials in Github(Github integration with aws)

#### Go to this pject in github and look for settings

<img width="2422" height="1358" alt="Image" src="https://github.com/user-attachments/assets/7251f0f6-0abe-4a02-a2d2-7c6fbdd03131" />

#### go look for secrete and variables

<img width="2540" height="1140" alt="Image" src="https://github.com/user-attachments/assets/2eabd929-5cb8-4583-91c3-48d152960160" />

#### click on actions and enter your aws credentials
access key 
and secret keys

<img width="2434" height="1124" alt="Image" src="https://github.com/user-attachments/assets/f23f806d-94cc-4a44-967c-d5cf058978f4" />

#### Step 3:Running the git push on my local terminal

<img width="1700" height="474" alt="Image" src="https://github.com/user-attachments/assets/72b87a17-67ec-4fc8-9ede-fd5abdb6ba0a" />


#### As shown git push trigers github to kick start the github actions pipeline actions as shown below 

<img width="2532" height="1140" alt="Image" src="https://github.com/user-attachments/assets/0e633b9f-13c6-4240-a25f-1138fa2975bb" />


<img width="2526" height="1272" alt="Image" src="https://github.com/user-attachments/assets/6e45fa42-d6bf-4783-a7d6-61e9e8b98642" />


#### If git push is ruan again miatekingly youn get bthe response below

<img width="2544" height="1268" alt="Image" src="https://github.com/user-attachments/assets/5bed1a46-85d6-439a-ab9e-5f40a1b2bc3f" />

#### Step 4:The two ec2 instancces installed with github actions cicd

<img width="1720" height="1302" alt="Image" src="https://github.com/user-attachments/assets/e073099f-48b0-443f-b300-0109ede2070a" />



#### output of the nginx webserver on the first server

<img width="1976" height="1274" alt="Image" src="https://github.com/user-attachments/assets/296a9c45-d4cc-45c8-aacf-6fa0d51088c3" />

#### output of the apache2 webserver on the second server

<img width="1934" height="1292" alt="Image" src="https://github.com/user-attachments/assets/d078252c-d545-4d5f-8ab8-fb5697365402" />



============
#### STAGE 2: CLEAN UP
==============

#### step1 : Destroy the resources created

#### run terraform destroy 

<img width="1250" height="718" alt="Image" src="https://github.com/user-attachments/assets/3a8a66f6-40e7-4aa8-ad9f-57b41e5fde4f" />


<img width="2288" height="1364" alt="Image" src="https://github.com/user-attachments/assets/070499cd-54c4-4d6b-a49e-2a6b2c64798e" />


<img width="2510" height="1132" alt="Image" src="https://github.com/user-attachments/assets/74874182-249d-42f9-b00a-f541bbdac9fd" />


<img width="2058" height="606" alt="Image" src="https://github.com/user-attachments/assets/18d16dca-6eba-4ac0-a600-351d896d9e91" />