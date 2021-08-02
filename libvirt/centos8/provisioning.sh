#!/usr/bin/bash

# Enable remote ssh
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/PrintMotd yes/PrintMotd no/g' /etc/ssh/sshd_config
sed -i 's/PrintLastLog yes/PrintLastLog no/g' /etc/ssh/sshd_config
systemctl restart sshd

# Disable SELinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

# Disable Firewall
systemctl stop firewalld && systemctl disable firewalld

# Update and install aditional packages
yum update -y
yum install -y epel-release 
yum clean all
yum install -y git jq curl wget net-tools yum-utils sysstat tree stress redhat-lsb* lsof

timedatectl set-timezone Europe/Madrid

# Evironment customization
cp /vagrant/update-motd.sh /etc/update-motd
chmod 755 /etc/update-motd
grep -qF 'update-motd' /etc/profile || echo "[ -x /etc/update-motd ] && /etc/update-motd" >>/etc/profile
grep -qxF "alias l='ls -la'" ~/.bashrc || echo "alias l='ls -la'" >>~/.bashrc
grep -qxF 'unalias ls' ~/.bashrc || echo "unalias ls" >>~/.bashrc
