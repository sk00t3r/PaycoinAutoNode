#!/bin/bash
echo "### Change to home directory"
cd ~
echo "### Installing sudo"
yum install sudo -y
echo "### Updating Ubuntu/Debian"
sudo yum update -y
sudo yum upgrade -y
sudo yum install unzip -y
sudo yum install cronie -y
sudo yum install nano -y
sudo yum install epel-release -y
sudo yum install firewalld -y
echo "### Start FirewallD, allow ports 22, 80, 8998, 8999 and reload"
sudo systemctl start firewalld
sudo firewall-cmd --zone=public --add-port=22/tcp --permanent
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
sudo firewall-cmd --zone=public --add-port=8998/tcp --permanent
sudo firewall-cmd --zone=public --add-port=8999/tcp --permanent
sudo firewall-cmd --reload
#sudo iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
#sudo iptables -A INPUT -p tcp -m tcp --dport 8998 -j ACCEPT
#sudo iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
#sudo iptables -A INPUT -p tcp -m tcp --dport 8999 -j ACCEPT
#sudo iptables-save
echo "### Creating Swap File"
dd if=/dev/zero of=/swapfile bs=1M count=1024 ; mkswap /swapfile ; swapon /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
#sudo ./create_swap.sh 4096
echo "### Creating paycoin.conf"
mkdir ~/.paycoin/
config=".paycoin/paycoin.conf"
touch $config
echo "server=1" > $config
echo "daemon=1" >> $config
echo "maxconnections=125" >> $config
echo "disablewallet=1" >> $config
randUser=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30`
randPass=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30`
echo "rpcuser=$randUser" >> $config
echo "rpcpassword=$randPass" >> $config
echo "### Downloading Paycoin Core 0.3.2.0"
wget https://github.com/PaycoinFoundation/paycoin/releases/download/v0.3.2.0/linux64.zip
echo "### Installing Paycoin Core 0.3.2.0"
unzip linux64.zip
rm -f -r linux64.zip
rm -f -r paycoin-qt
echo "### Changing to paycoind directory"
cd ~
echo "### Stopping Paycoin Server"
./paycoind stop
echo "### Changing to home directory"
cd ~
echo "### Installing pip and apache2"
sudo yum install python-pip -y
sudo yum install httpd -y
sudo chkconfig --levels 235 httpd on
echo "### Updating pip"
sudo sudo pip install --upgrade pip
echo "### Installing python-bitcoinrpc"
sudo pip install python-bitcoinrpc
echo "### Changing to paycoind directory"
cd ~
echo "### Starting Paycoin Server"
./paycoind
echo "### Changing to home directory"
cd ~
echo "### IN 15 SECONDS PLEASE WRITE DOWN YOUR RPCUSER AND RPCPASSWORD AND PRESS CTRL+X (WE WILL NEED THESE SOON)"
sleep 15
cd .paycoin
nano paycoin.conf
echo "### Changing to home directory"
cd ~
echo "### Downloading the Web Interface"
mkdir ~/WebInterface/
cd ~/WebInterface/
wget -O osversion.py https://raw.githubusercontent.com/sk00t3r/PaycoinAutoNode/1-step-install/osversion.py
wget -O cpu.py https://raw.githubusercontent.com/sk00t3r/PaycoinAutoNode/1-step-install/cpu.py
wget -O server_uptime.py https://raw.githubusercontent.com/sk00t3r/PaycoinAutoNode/1-step-install/server_uptime.py
wget -O WebInterface.py https://raw.githubusercontent.com/sk00t3r/PaycoinAutoNode/1-step-install/WebInterface.py
echo "### IN 15 SECONDS CONFIGURE WEBINTERFACE.PY WITH RPC_USER, RPC_PASS, NODE_LOCATION, NODE_NAME, NODE_IP, DONATION_XPY_ADDR AND EXIT (DON’T FORGET TO SAVE)"
sleep 15
nano WebInterface.py
echo "### Installing the Web Interface"
sudo python WebInterface.py
echo "### Changing to home directory"
cd ~
echo "### Scheduling Cron Job to run Paycoin Core on boot and WebInterface.py every minute."
(crontab -l ; echo "@reboot ~/./paycoind")| crontab -
(crontab -l ; echo "*/1 * * * * sudo python ~/WebInterface/WebInterface.py")| crontab -
echo "### System will now reboot"
reboot
