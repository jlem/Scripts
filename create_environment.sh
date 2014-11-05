#!/bin/bash

# The purpose of this script is to create a new apache vhost / environment

# First, create the vhost
# Second, add the .dev domain to the hosts file
# Third, restart apache

source ~/Scripts/colors.sh

# If name is not set by another script, prompt for it here 
if [ -z "$name" ]
    then 
        source ~/Scripts/prompts/environment.sh
fi


# If counter is not set by another script, initialize at 1
if [ -z "$counter" ]
    then
        counter=1
fi

# 1. Create the vhost conf
sudo tee /etc/apache2/other/$name.conf &> /dev/null <<EOF
NameVirtualHost *:80
<Virtualhost *:80>
    ServerName $name.dev
    ServerAlias www.$name.dev
    DocumentRoot /var/www/$name

    <Directory "/var/www/$name">
		AllowOverride All
		Options Indexes MultiViews FollowSymLinks
		Require all granted
    </Directory>
</VirtualHost>
EOF
echo -e "${counter}. ${green}Vhost ${yellow} '$name.conf'${green} created.${end}\n"
counter=$[counter + 1]

# 2. Append new url to hosts
sudo tee -a /etc/hosts &> /dev/null <<EOF
127.0.0.1 $name.dev
EOF
echo -e "${counter}. ${green}Host ${yellow} '$name.dev'${green} created.${end}\n"
counter=$[counter + 1]

# 3. Restart apache
sudo apachectl restart
echo -e "${counter}. ${green}Apache restarted.${end}\n"
counter=$[counter + 1]
