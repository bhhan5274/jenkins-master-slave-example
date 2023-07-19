#!/bin/sh

set -e

sudo yum update -y

# Jenkins Install (Jenkins Default Path => /var/lib/jenkins)
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
#sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key => deprecated
sudo yum install -y jenkins

# Java Install
sudo yum install -y java-11-amazon-corretto

# Git Install
sudo yum install -y git

# Docker Install
sudo yum install -y docker
sudo systemctl enable docker
sudo systemctl start docker
sudo chmod 666 /var/run/docker.sock

# EFS Path Mount
sudo yum -y install amazon-efs-utils
sudo su -c  "echo '${file_system_id}:/ ${efs_mount_point} efs _netdev,tls 0 0' >> /etc/fstab"
sudo mount ${efs_mount_point}
df -k

# Swap Memory Configuration
sudo mkdir -p /var/spool/swap
sudo touch /var/spool/swap/swapfile
sudo dd if=/dev/zero of=/var/spool/swap/swapfile count=2048000 bs=1024
sudo chmod 600 /var/spool/swap/swapfile
sudo mkswap /var/spool/swap/swapfile
sudo swapon /var/spool/swap/swapfile
echo "/var/spool/swap/swapfile    none    swap    defaults    0 0" | sudo tee -a /etc/fstab > /dev/null

# Directory UserGroup Add
sudo chown jenkins:jenkins ${efs_mount_point}

sudo systemctl enable jenkins
sudo systemctl start jenkins
