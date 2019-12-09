#!/bin/bash

install()
{
#	ansible-playbook -i inventario /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml;

	echo "---------- deploy_cluster - Start "
	ansible-playbook -i inventario /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml;
	echo "---------- deploy_cluster - Finish"

	sleep 360

	echo "---------- openshift-monitoring - Start"
	ansible-playbook -i inventario /usr/share/ansible/openshift-ansible/playbooks/openshift-monitoring/config.yml 
	echo "---------- openshift-monitoring - Finish "

        sleep 360

	echo "---------- metrics-server - Start"
	ansible-playbook -i inventario /usr/share/ansible/openshift-ansible/playbooks/metrics-server/config.yml
        echo "---------- metrics-server - Finish "

        sleep 360

	echo "---------- openshift-metrics - Start "
	ansible-playbook -i inventario /usr/share/ansible/openshift-ansible/playbooks/openshift-metrics/config.yml
        echo "---------- openshift-metrics - Finish "

        sleep 360

	echo "---------- openshift-logging - Start "
	ansible-playbook -i inventario /usr/share/ansible/openshift-ansible/playbooks/openshift-logging/config.yml
	echo "---------- openshift-logging - Finish "

	
	
}

time install
