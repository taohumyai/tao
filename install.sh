#!/bin/bash
#
# Mod by Dv-server
# ==================================================
echo "<BODY text='ffffff'>" > admin.sh
clear
# go to root
cd

# Install Command
apt-get -y install ufw
apt-get -y install sudo

# set repo
wget -O /etc/apt/sources.list "https://raw.githubusercontent.com/taohumyai/ta/master/sources.list.debian8"
wget "https://raw.githubusercontent.com/taohumyai/ta/master/dotdeb.gpg"
wget "https://raw.githubusercontent.com/taohumyai/ta/master/jcameron-key.asc"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg
cat jcameron-key.asc | apt-key add -;rm jcameron-key.asc

# update
apt-get update

# install webserver
apt-get -y install nginx

# install essential package
apt-get -y install nano iptables dnsutils openvpn screen whois ngrep unzip unrar

echo -e "\033[1;32m "
# install neofetch
echo "deb http://dl.bintray.com/dawidd6/neofetch jessie main" | sudo tee -a /etc/apt/sources.list
curl -L "https://bintray.com/user/downloadSubjectPublicKey?username=bintray" -o Release-neofetch.key && sudo apt-key add Release-neofetch.key && rm Release-neofetch.key
apt-get update
apt-get install neofetch

echo "clear" >> .bashrc
echo -e " "
echo 'echo -e "\033[01;32m  }~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{"' >> .bashrc
echo 'echo -e "  {    Wallcom to server Debian7-8     }"' >> .bashrc
echo 'echo -e "  }~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{"' >> .bashrc
echo 'echo -e "  { Script mod by  Dv-Server }"' >> .bashrc
echo 'echo -e "  }~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{"' >> .bashrc
echo 'echo -e "  {   prin { menu } Show menu items    }"' >> .bashrc
echo 'echo -e "  }~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{"' >> .bashrc
echo -e "\033[1;33m"

# setting time
ln -fs /usr/share/zoneinfo/Asia/Bangkok /etc/localtime
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# install webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/taohumyai/ta/master/nginx.conf"
mkdir -p /home/vps/public_html
echo "smile" > /home/vps/public_html/index.html
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/taohumyai/ta/master/vps.conf"
service nginx restart

echo -e "\033[1;34m"
# install openvpn
wget -O /etc/openvpn/openvpn.tar "https://raw.githubusercontent.com/taohumyai/ta/master/openvpn-debian.tar"
cd /etc/openvpn/
tar xf openvpn.tar
wget -O /etc/openvpn/1194.conf "https://raw.githubusercontent.com/taohumyai/ta/master/1194.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
iptables -t nat -I POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
iptables-save > /etc/iptables_yg_baru_dibikin.conf
wget -O /etc/network/if-up.d/iptables "https://raw.githubusercontent.com/taohumyai/ta/master/iptables"
chmod +x /etc/network/if-up.d/iptables
service openvpn restart

echo -e "\033[1;35m "
# konfigurasi openvpn
cd /etc/openvpn/
wget -O /etc/openvpn/Test.ovpn "https://raw.githubusercontent.com/taohumyai/ta/master/client-1194.conf"
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
sed -i s/xxxxxxxxx/$MYIP/g /etc/openvpn/Test.ovpn;
cp Test.ovpn /home/vps/public_html/

echo -e "\033[1;36m "
# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/taohumyai/ta/master/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/taohumyai/ta/master/badvpn-udpgw64"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

echo -e "\033[1;31m "
# setting port ssh
cd
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
service ssh restart

echo -e "\033[1;32m "
# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 443 -p 80"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
service ssh restart
service dropbear restart

echo -e "\033[1;33m"
# Install Squid
apt-get -y install squid3
cp /etc/squid3/squid.conf /etc/squid3/squid.conf.orig
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/taohumyai/ta/master/squid3.conf" 
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
sed -i s/xxxxxxxxx/$MYIP/g /etc/squid3/squid.conf;
service squid3 restart


# install webmin
cd
wget "http://prdownloads.sourceforge.net/webadmin/webmin_1.870_all.deb"
dpkg --install webmin_1.870_all.deb;
apt-get -y -f install;
rm /root/webmin_1.870_all.deb
service webmin restart
service vnstat restart

echo -e "\033[1;35m"
# download script
cd /usr/bin
wget -O menu "https://raw.githubusercontent.com/taohumyai/ta/master/menu.sh"
wget -O a "https://raw.githubusercontent.com/taohumyai/ta/master/adduser.sh"
wget -O b "https://raw.githubusercontent.com/taohumyai/ta/master/testuser.sh"
wget -O c "https://raw.githubusercontent.com/taohumyai/ta/master/rename.sh"
wget -O d "https://raw.githubusercontent.com/taohumyai/ta/master/repass.sh"
wget -O e "https://raw.githubusercontent.com/taohumyai/ta/master/delet.sh"
wget -O f "https://raw.githubusercontent.com/taohumyai/ta/master/deletuserxp.sh"
wget -O g "https://raw.githubusercontent.com/taohumyai/ta/master/viewuser.sh"
wget -O h "https://raw.githubusercontent.com/taohumyai/ta/master/restart.sh"
wget -O i "https://raw.githubusercontent.com/taohumyai/ta/master/speedtest.py"
wget -O j "https://raw.githubusercontent.com/taohumyai/ta/master/online.sh"
wget -O k "https://raw.githubusercontent.com/taohumyai/ta/master/viewlogin.sh"
wget -O l "https://raw.githubusercontent.com/taohumyai/ta/master/aboutsystem.sh"
wget -O m "https://raw.githubusercontent.com/taohumyai/ta/master/lock.sh"
wget -O n "https://raw.githubusercontent.com/taohumyai/ta/master/unlock.sh"
wget -O o "https://raw.githubusercontent.com/taohumyai/ta/master/httpinstall.sh"
wget -O p "https://raw.githubusercontent.com/taohumyai/ta/master/httpcredit.sh"
wget -O q "https://raw.githubusercontent.com/taohumyai/ta/master/aboutscrip.sh"
wget -O r "https://raw.githubusercontent.com/taohumyai/ta/master/TimeReboot.sh"

echo "30 3 * * * root /sbin/reboot" > /etc/cron.d/reboot

chmod +x menu
chmod +x a
chmod +x b
chmod +x c
chmod +x d
chmod +x e
chmod +x f
chmod +x g
chmod +x h
chmod +x i
chmod +x j
chmod +x k
chmod +x l
chmod +x m
chmod +x n
chmod +x o
chmod +x p
chmod +x q
chmod +x r

echo -e "\033[1;36m "
# finishing
cd
chown -R www-data:www-data /home/vps/public_html
service nginx start
service openvpn restart
service cron restart
service ssh restart
service dropbear restart
service squid3 restart
service webmin restart
rm -rf ~/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile

# info
clear
echo -e "\033[1;32m =============
 Smile figther
 =============
 Service 
 ---------------------------------------------
 OpenSSH  : 22, 143 
 Dropbear : 80, 443 
 Squid3   : 8080, 3128 (limit to IP SSH) 
 Config   : OpenVPN (TCP 1194)
 =============================================
 badvpn   : badvpn-udpgw port 7300 
 nginx    : 81 
 Webmin   : http://$MYIP:10000/ 
 Timezone : Asia/Thailand (GMT +7) 
 IPv6     : [off] 
 =============================================
 Credit.  :  Dev By. Tao
 FaceBook :  https://www.facebook.com/T4O.iT
 Line ID  :  taohumyai
 Wallet   :  0959965558
 ============================================="
echo " VPS AUTO REBOOT 00.00"
echo " ===================================== " 
echo " Enter { menu } show list on menu "
echo " ===================================== "
cd
rm -f admin.sh
rm -f install.sh
