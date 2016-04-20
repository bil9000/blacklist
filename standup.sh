#!/bin/bash
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get install debconf-utils git -y
sudo apt-get install zip wamerican-small -y


password4now="$(shuf -n1 /usr/share/dict/words)"
echo "$password4now" 

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password $password4now'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password $password4now'
sudo apt-get install lamp-server^ -y
#sudo apt-get install phpmyadmin -y
mysql -uroot -p$password4now -e "GRANT ALL PRIVILEGES ON wp.* To 'wp'@'localhost' IDENTIFIED BY 'wp_changemesoon';"
sudo /etc/init.d/apache2 start
sudo /etc/init.d/mysql start
cd /home/ubuntu
sudo mv /var/www/html/index.html /var/www/html/indexBU.html

wget https://wordpress.org/latest.zip
unzip latest.zip 
sudo mv  wordpress/* /var/www/html/

sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true' 
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password changemesoon' 
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password changemesoon' 
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password changemesoon' 
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' 

sudo export DEBIAN_FRONTEND=noninteractive
sudo apt-get install phpmyadmin -y -q


mysql -uroot -p$password4now -ed "GRANT ALL PRIVILEGES ON wp.* To 'wp'@'localhost' IDENTIFIED BY '$password4now';"

echo $password4now
echo '<--- is the password, we'll also dump it to a local text file called `.yomamma`'
echo $password4now > .yomamma