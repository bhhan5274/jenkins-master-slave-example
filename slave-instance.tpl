#!/bin/sh

set -e

sudo yum update -y

# Java Install
sudo yum install -y java-11-amazon-corretto

# Git Install
sudo yum install -y git

# Docker Install
sudo yum install -y docker
sudo systemctl enable docker
sudo systemctl start docker
sudo chmod 666 /var/run/docker.sock

# Swap Memory Configuration
sudo mkdir -p /var/spool/swap
sudo touch /var/spool/swap/swapfile
sudo dd if=/dev/zero of=/var/spool/swap/swapfile count=2048000 bs=1024
sudo chmod 600 /var/spool/swap/swapfile
sudo mkswap /var/spool/swap/swapfile
sudo swapon /var/spool/swap/swapfile
echo "/var/spool/swap/swapfile    none    swap    defaults    0 0" | sudo tee -a /etc/fstab > /dev/null
