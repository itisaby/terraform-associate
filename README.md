# Terraform-Associate Practice

In this Repo I will be adding whatever I learn in Terraform <br>
1. Terraform-Beginner
    - Terraform File Structure
    - Providers in Terraform 
    - Locals in Terraform 
    - Variables in Terraform(.tfvars file)
    - Creating an EC2 Instance
    - AWS VPC
2. Created a Dev Env using Terraform in aws. 
    - Creating an EC2 Instance
    - Passing info of AMI Instance through data source
    - AWS VPC 
    - Subnet and Referencing
    - Internet Gateways, Route Tables
    - Security Groups
    - Sending user data from a .tpl file(can also use .sh file)
    - SSH into EC2 using rsa key value pair 
    - Using local exec command to SSH into EC2 through VSCODE
    - Remote-SSH Extension to access the EC2 instance
    - Conditional Statements and Outputs 

## How to get started
1. Clone this repo 
2. Install Terraform from <a href="https://www.terraform.io/downloads">Terraform.io</a>.
3. Move to any directory and run `terraform init`.
4. Since this is done on AWS so u need to configure the following
    - Have an AWS account
    - Create an IAM user with the required access
    - Configure AWS CLI.

5. At first run `Terraform Plan` it will show which resources will be created.
6. Run the Command `terraform apply` which will give a prompt and you can say yes and it will create all the resources. Alternatively you can run `terraform apply -auto-approve`. 