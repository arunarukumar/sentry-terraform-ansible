Self-Hosted Sentry Deployment with Terraform and Ansible
This repository contains infrastructure-as-code (IaC) and configuration management scripts to deploy a self-hosted instance of Sentry. We use Terraform to provision the required AWS infrastructure and Ansible to automate the installation and setup of Sentry on the server.

Overview
Project Structure
main.tf - Defines the AWS resources required for the Sentry server, such as EC2, VPC, and security groups.
inventory.ini - An Ansible inventory file containing the IPs of the target servers for configuration.
install_sentry.yml - An Ansible playbook that installs and configures Docker, Docker Compose, and Sentry.
aws/ - Directory containing any additional AWS-related configuration files.
.gitignore - Defines files to be ignored by Git (such as sensitive credentials and large binaries).
task_altair.pem - SSH key file for server access (not included in the repository for security).
Prerequisites
Ensure the following tools are installed and configured on your local system:

AWS CLI - To manage AWS resources.
Terraform - To define and deploy AWS infrastructure.
Ansible - To automate Sentry setup on the target server.
Docker - Installed on the target server to run Sentry containers.
Setup Guide
1. Clone the Repository
Start by cloning this repository to your local machine:

git clone https://github.com/arunarukumar/sentry-terraform-ansible.git
cd sentry-terraform
2. Configure AWS CLI
Make sure AWS CLI is configured with credentials that have permissions to create EC2 instances and manage other required resources:

aws configure
3. Provision AWS Infrastructure with Terraform
Use Terraform to provision an EC2 instance and set up the required network resources:

Initialize Terraform:

terraform init
Apply Terraform Configuration:

terraform apply
Terraform will prompt for confirmation. Type yes to proceed with creating the resources.

Output the Server IP: Once provisioning completes, note the EC2 instance's public IP.

4. Configure Ansible Inventory
Edit inventory.ini to include the IP of the EC2 instance that Terraform created. Example:

[all]
instance ip ansible_ssh_private_key_file=task_altair.pem ansible_user=ubuntu
5. Run Ansible Playbook to Install Sentry
Use Ansible to install and configure Docker, Docker Compose, and the Sentry application on the server.

ansible-playbook -i inventory.ini install_sentry.yml
This playbook will:

Update the system packages.
Install Docker and Docker Compose.
Clone the Sentry repository.
Start Sentry using Docker Compose.
6. Access Sentry
Once the playbook completes, access Sentry by navigating to the public IP of the server in a web browser:

http://<SERVER_PUBLIC_IP>
Usage
Log in to the Sentry UI to complete the setup and configure projects for monitoring.
Configure Sentry SDKs in your applications to send error data to this self-hosted Sentry instance.
Clean Up Resources
To remove the infrastructure and avoid ongoing costs, run:

terraform destroy
Troubleshooting

Check Docker Logs: If Sentry does not start as expected, use the following command on the server to view logs:

docker-compose logs -f
SSH Issues
Verify the SSH key file path in inventory.ini matches the correct key path and permissions.
Terraform Issues
If you encounter resource conflicts, try running terraform refresh to sync state or manually clear problematic resources in the AWS Console.
Security Considerations
Keep task_altair.pem secure and restrict its permissions.
Do not expose Sentry to the public internet without additional security measures like IP whitelisting or VPN.
