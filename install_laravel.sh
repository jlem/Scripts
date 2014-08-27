#!/bin/bash

# The purpose of this script is to install a new laravel project into a given project

# First, the laravel installer will be used
# Second, the project will be properly chowned and chmodded
# Third (TODO), set environment as local
# Fourth, create a database
# Fifth, create a .env file

source ~/Scripts/colors.sh

# If name is not set by another script, prompt for it here 
if [ -z "$name" ]
    then 
        source ~/Scripts/prompts/project.sh
fi

# If counter is not set by another script, initialize at 1
if [ -z "$counter" ]
    then
        counter=1
fi

# 1. Install laravel
cd /var/www
~/.composer/vendor/bin/laravel new $name &> /dev/null
echo -e "${counter}. ${green}New laravel project installed into${yellow} '/var/www/$name'${end}\n"
counter=$[counter + 1]

# 2. Change permissions
sudo chown -R Jon:_www $name/
sudo chmod -R 775 $name/
echo -e "${counter}. ${green}Permissions fixed.${end}\n"
counter=$[counter + 1]

# 3. Create database
mysql -uroot << EOF
create database $name
EOF
echo -e "${counter}. ${green}Database${yellow} '$name' ${green}created.${end}\n"
counter=$[counter + 1]

#4. Create the .env file
cd /var/www/$name
cat <<EOF > .env.php
<?php
return [
    'dbhost' => 'localhost',
    'dbname' => '$name',
    'dbuser' => 'root',
    'dbpass' => ''
];
EOF
echo -e "${counter}. ${green}Environment config created.${end}\n"
counter=$[counter + 1]
