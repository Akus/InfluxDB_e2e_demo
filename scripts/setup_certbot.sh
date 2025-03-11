#!/bin/bash

# Install Certbot
sudo apt update
sudo apt install -y certbot

# Create a directory for Certbot logs and config
sudo mkdir -p /etc/letsencrypt/logs
sudo mkdir -p /etc/letsencrypt/config

# Obtain SSL certificates from Let's Encrypt
sudo certbot certonly --standalone -d akos-bodor.com --agree-tos --email akosbodor@gmail.com --non-interactive

echo "Certbot and SSL certificate setup complete."
