#!/bin/bash

install()
{
	ansible-playbook -i inventario /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml;
	ansible-playbook -i inventario /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml;
	ansible-playbook -i inventario /usr/share/ansible/openshift-ansible/playbooks/openshift-monitoring/config.yml 
}

time install
