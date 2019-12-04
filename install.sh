#!/bin/bash

install()
{
	ansible-playbook -i inventario /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml;
	ansible-playbook -i inventario /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml;
	ansible-playbook -i inventario /usr/share/ansible/openshift-ansible/playbooks/openshift-monitoring/config.yml 
	ansible-playbook -i inventario /usr/share/ansible/openshift-ansible/playbooks/metrics-server/config.yml
	ansible-playbook -i inventario /usr/share/ansible/openshift-ansible/playbooks/openshift-metrics/config.yml
	ansible-playbook -i inventario /usr/share/ansible/openshift-ansible/playbooks/openshift-logging/config.yml
	
}

time install
