#!/bin/bash
echo "### Change to home directory"
cd ~
echo "### Installing sudo"
apt-get install sudo -y
echo "### Update Ubuntu"
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install software-properties-common python-software-properties unzip ufw python-pip apache2 -y
echo "### Installing python-bitcoinrpc"
sudo pip install python-bitcoinrpc
echo "### Allow ports 22, 80 & 8998 and enable The Uncomplicated Firewall"
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 8998/tcp
sudo ufw --force enable
echo "### Creating Swap File"
dd if=/dev/zero of=/swapfile bs=1M count=1024 ; mkswap /swapfile ; swapon /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
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
echo "### Changing to home directory"
cd ~
echo "### IN 30 SECONDS PLEASE WRITE DOWN YOUR RPCUSER AND RPCPASSWORD AND PRESS CTRL+X (WE WILL NEED THESE SOON)"
sleep 10
cd .paycoin
nano paycoin.conf
echo "### Changing to home directory"
cd ~
echo "### Downloading the Web Interface"
mkdir ~/WebInterface/
cd ~/WebInterface/
wget -O uptime.py https://raw.githubusercontent.com/sk00t3r/PaycoinAutoNode/master/uptime.py
wget -O WebInterface.py https://raw.githubusercontent.com/sk00t3r/PaycoinAutoNode/master/WebInterface.py
echo "### IN 30 SECONDS CONFIGURE WEBINTERFACE.PY WITH RPC_USER, RPC_PASS, NODE_LOCATION, NODE_NAME, NODE_IP, DONATION_XPY_ADDR AND EXIT (DON’T FORGET TO SAVE)"
sleep 10
nano WebInterface.py
echo "### Installing the Web Interface"
sudo python WebInterface.py
echo "### Scheduling Cron Job to run Paycoin Core on boot and WebInterface.py every 5 minutes"
(crontab -l ; echo "@reboot ~/./paycoind")| crontab -
(crontab -l ; echo "*/5 * * * * sudo python ~/WebInterface/WebInterface.py")| crontab -
echo "### System will now reboot"
reboot
