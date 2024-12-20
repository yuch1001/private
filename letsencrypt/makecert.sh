#!/bin/bash

# Let's Encrypt SSL Certificate Issuance Script
# Requirements: Certbot must be installed

# fe7ef1.o-r.kr
# yuchlove0@gmail.com

echo "Let's Encrypt SSL Certificate Issuance Script"
echo "============================================="

# Prompt for the domain
read -p "Enter the domain name for the SSL certificate (e.g., example.com): " DOMAIN
if [ -z "$DOMAIN" ]; then
  echo "No domain name entered. Exiting."
  exit 1
fi

# Prompt for email address
read -p "Enter your email address (e.g., admin@example.com): " EMAIL
if [ -z "$EMAIL" ]; then
  echo "No email address entered. Exiting."
  exit 1
fi

read -p "Are you using Nginx(n), Apache(s), or Manual(m)? (): " WEB_SERVER

if [[ "$WEB_SERVER" == "n" ]]; then
  echo "Web server detected. Configuring Certbot for Nginx..."
  SERVER_MODE="--nginx"
  SERVER_ADD_ARG=" --agree-tos --non-interactive"
elif [[ "$WEB_SERVER" == "s" ]]; then
  echo "Web server detected. Configuring Certbot for Standalone mode..."
  SERVER_MODE="--standalone"
  SERVER_ADD_ARG=" --agree-tos --non-interactive"
elif [[ "$WEB_SERVER" == "m" ]]; then
  echo "Manual mode selected. Configuring Certbot for DNS challenges..."
  SERVER_MODE="--manual --preferred-challenges dns"
else
  echo "Invalid input. Please select a valid option (n, s, m). Exiting..."
  exit 1
fi


# Run Certbot to obtain the certificate
echo "Running Certbot to obtain the certificate..."
sudo certbot certonly $SERVER_MODE -d "$DOMAIN" --email "$EMAIL""$SERVER_ADD_ARG"

# Check the result
if [ $? -eq 0 ]; then
  echo "The SSL certificate was successfully issued!"
  echo "The certificate is stored in /etc/letsencrypt/live/$DOMAIN/"

  # Define the source directory where Certbot saves the certificates
  CERT_DIR="/etc/letsencrypt/live/$DOMAIN"

  # Copy the certificates to the current directory
  echo "Copying the certificate files to the current directory..."

  cp "$CERT_DIR/fullchain.pem" ./
  cp "$CERT_DIR/privkey.pem" ./

  echo "Certificates have been copied to the current directory."
else
  echo "Failed to issue the certificate. Check the Certbot logs for more details."
  exit 1
fi
