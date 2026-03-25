#!/bin/bash

# -----------------------------
# Update system
# -----------------------------
sudo apt update -y
sudo apt upgrade -y

# -----------------------------
# Install Java (Required for Jenkins)
# -----------------------------
sudo apt install openjdk-21-jdk -y

# Verify Java
java -version

# -----------------------------
# Add Jenkins repo
# -----------------------------
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# -----------------------------
# Install Jenkins
# -----------------------------
sudo apt update -y
sudo apt install jenkins -y

# Enable & Start Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Check status
sudo systemctl status jenkins

# -----------------------------
# Install Git
# -----------------------------
sudo apt install git -y

# -----------------------------
# Install Terraform
# -----------------------------
sudo apt install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update -y
sudo apt install terraform -y

# Verify Terraform
terraform -version

# -----------------------------
# Install kubectl
# -----------------------------
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Verify kubectl
kubectl version --client

# -----------------------------
# Final Message
# -----------------------------
echo "Setup Complete! Access Jenkins at http://<your-ip>:8080"