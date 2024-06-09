#!/bin/bash

# Variables
app_dir="/var/www/app"
ws_s_available="/etc/nginx/sites-available"
ws_s_enabled="/etc/nginx/sites-enabled"

sudo apt update

sudo apt install -y nginx

sudo rm -f "$ws_s_available"/default
sudo rm -f "$ws_s_enabled"/default

sudo mv /tmp/mydomain.conf "$ws_s_available"

sudo chown www-data:www-data "$ws_s_available"/mydomain.conf

sudo chmod 644 "$ws_s_available"/mydomain.conf

sudo ln -s "$ws_s_available"/mydomain.conf "$ws_s_enabled"/mydomain.conf

# Add repository and install Nodejs
sudo curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash - && sudo apt install -y nodejs

# Install build-essential
sudo apt install -y build-essential

# Install pm2
sudo npm install pm2@latest -g

sudo mkdir "$app_dir"

sudo mv /tmp/app.js "$app_dir"

cd "$app_dir"

# Initialize the application project
sudo npm init -y

# Install application dependencies
sudo npm install express mongoose

# Starting the app.js application with pm2
sudo pm2 start "$app_dir"/app.js --name 'App'

# Configure pm2 to start the application at system startup
eval $(pm2 startup | grep 'sudo' | sed -e 's/.*\[sudo\] //')

# Save pm2 settings
sudo pm2 save

sudo systemctl restart nginx

sudo shutdown -r now

logger "WebApp server installation and configuration successfully completed"