#!/bin/bash
apt update
apt install -y apache2

# Install the AWS CLI
apt install -y awscli


# Start Apache and enable it on boot
systemctl start apache2
systemctl enable apache2