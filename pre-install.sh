#!/bin/bash

host_full=ocp-all-in-one01.example.com
host=ocp-all-in-one01
ip="192.168.100.250"
gw="192.168.100.1"
vm_path="OCP"


cat /root/.bashrc|egrep -v "GOVC" > /tmp/.bashrc
echo "export GOVC_URL='192.168.100.102'"                  >> /tmp/.bashrc
echo "export GOVC_USERNAME='administrator@vsphere.local'" >> /tmp/.bashrc
echo "export GOVC_PASSWORD='W@ster123'"                   >> /tmp/.bashrc
echo "export GOVC_INSECURE=1"                             >> /tmp/.bashrc
mv -f /tmp/.bashrc /root/.bashrc
. /root/.bashrc


conf_hostname()
{
	echo " "
	echo "---- hostname"
	hostnamectl set-hostname $host_full
	hostname
}

conf_network()
{
	echo " "
	echo "---- network"
	cat /etc/sysconfig/network-scripts/ifcfg-ens192 |egrep -v "BOOTPROTO|IPADDR|GATEWAY|NETMAKS|DNS1" > /tmp/network
	echo "IPADDR=$ip"            >> /tmp/network
	echo "GATEWAY=$gw"           >> /tmp/network
	echo "NETMAKS=255.255.255.0" >> /tmp/network
	echo "BOOTPROTO=static"      >> /tmp/network
	echo "DNS1=$gw"              >> /tmp/network
	cat /tmp/network
	mv -f /tmp/network /etc/sysconfig/network-scripts/ifcfg-ens192
}



conf_hosts()
{
	echo " "
	echo "---- /etc/hosts"
	echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4" > /etc/hosts
	echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/hosts
	echo "$ip $host_full $host" >> /etc/hosts
}



conf_sshkey()
{
	echo " "
	echo "---- ssh key "
	rm -rf /root/.ssh/*
	cat /dev/zero | ssh-keygen -q -N ""
	sshpass -p "jakarosa" ssh-copy-id -o StrictHostKeyChecking=no root@ocp02.example.com
}

conf_yum()
{
	echo " "
	echo "----- yum"
	#    8  subscription-manager register
	#    9  subscription-manager refresh
	#   10  subscription-manager list --available --matches '*OpenShift*'
	#   11  subscription-manager attch --pool=8a85f99b6e12cc13016e3baad78f45f0
	#   12  subscription-manager attach --pool=8a85f99b6e12cc13016e3baad78f45f0
	#   13  subscription-manager repos --disable="*"
	yum -y install atomic-openshift-clients openshift-ansible
	yum -y update
	yum install -y wget
}

conf_govc()
{
	curl -LO https://github.com/vmware/govmomi/releases/download/v0.15.0/govc_linux_amd64.gz
	gunzip -f govc_linux_amd64.gz
	chmod +x govc_linux_amd64
	mv -f govc_linux_amd64 /usr/bin/govc
	
	#[root@ocp ~]# cat .bashrc
	#
	#export GOVC_URL='192.168.100.102'
	#export GOVC_USERNAME='administrator@vsphere.local'
	#export GOVC_PASSWORD='W@ster123'
	#export GOVC_INSECURE=1
	##
	# $govc vm.change -e="disk.enableUUID=1" -vm='VM Path'
	
	vm_path_full=$(govc ls -L|grep vm)/$vm_path/$host_full
	echo $vm_path_full
	echo "govc vm.change -e=\"disk.enableUUID=1\" -vm='$vm_path_full'"|sh
	govc ls -L
}

conf_hostname
conf_network
conf_hosts
conf_sshkey
conf_yum
conf_govc



systemctl restart network
