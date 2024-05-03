#!/usr/bin/env bash

# Update package list
sudo apt-get update

# Install Nginx
sudo apt-get -y install nginx

# Allow Nginx through firewall
sudo ufw allow 'Nginx HTTP'

# Create directory structure for web_static
sudo mkdir -p /data/web_static/{releases,test,shared}

# Create a test index.html file
sudo tee /data/web_static/releases/test/index.html > /dev/null <<EOF
<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>
EOF

# Create a symbolic link to the test directory
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

# Change ownership to the ubuntu user
sudo chown -R ubuntu:ubuntu /data/

# Check if the location block exists before adding it
if ! sudo grep -q "location /hbnb_static" /etc/nginx/sites-enabled/default; then
    sudo sed -i '/listen 80 default_server/a location /hbnb_static { alias /data/web_static/current/;}' /etc/nginx/sites-enabled/default
fi

# Restart Nginx
sudo systemctl restart nginx
