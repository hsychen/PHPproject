#!/bin/bash

sudo yum update -y

sudo yum install yum-utils epel-release unzip rsyslog policycoreutils-python -y
sudo systemctl enable --now rsyslog
sudo yum install nodejs -y

sudo yum install https://centos7.iuscommunity.org/ius-release.rpm -y
sudo yum --enablerepo=ius install git222 -y

# sudo bash -c 'cat <<EOF > /etc/yum.repos.d/nginx.repo
# [nginx-stable]
# name=nginx stable repo
# baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
# gpgcheck=1
# enabled=1
# gpgkey=https://nginx.org/keys/nginx_signing.key
# module_hotfixes=true

# [nginx-mainline]
# name=nginx mainline repo
# baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
# gpgcheck=1
# enabled=0
# gpgkey=https://nginx.org/keys/nginx_signing.key
# module_hotfixes=true
# EOF'
sudo yum install nginx -y
sudo systemctl enable --now nginx

sudo yum install https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm -y
sudo yum install --enablerepo=mysql80-community mysql-community-server -y
sudo systemctl enable --now mysqld

sudo yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
sudo yum --enablerepo=remi-php74 install php php-pecl-zip php-mbstring php-xml php-fpm -y
sudo systemctl enable --now php-fpm

sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php -r "if (hash_file('sha384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php composer-setup.php
sudo php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer
sudo chown root:root /usr/local/bin/composer
sudo cp /usr/local/bin/composer /usr/local/sbin/composer

sudo bash -c 'cat <<EOF >> /etc/sysctl.conf
fs.inotify.max_user_watches=524288
EOF'
sudo sysctl -p

composer create-project --prefer-dist laravel/laravel PHPproject
