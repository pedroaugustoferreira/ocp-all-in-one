#!/bin/bash

install()
{
#	ansible-playbook -i inventario /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml;

	echo "---------- deploy_cluster - Start "
	ansible-playbook -i inventario_v1 /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml;
	echo "---------- deploy_cluster - Finish"
	
	sleep 120
	echo "---------- deploy_cluster"      > pods.txt
	echo "---------- deploy_cluster"      > pv.txt
	echo "---------- deploy_cluster"      > pvc.txt
	oc get pods --all-namespaces -o wide >> pods.txt
	oc get pv --all-namespaces -o wide   >> pv.txt
	oc get pvc --all-namespaces -o wide  >> pvc.txt
	

	echo "---------- metrics - Start"
	ansible-playbook -i inventario_v3 /usr/share/ansible/openshift-ansible/playbooks/metrics-server/config.yml
	sleep 120
	ansible-playbook -i inventario_v3 /usr/share/ansible/openshift-ansible/playbooks/openshift-metrics/config.yml
        echo "---------- metrics - Finish "

        sleep 120
	echo "---------- metrics"            >> pods.txt
	echo "---------- metrics"            >> pv.txt
	echo "---------- metrics"            >> pvc.txt
	oc get pods --all-namespaces -o wide >> pods.txt
	oc get pv --all-namespaces -o wide   >> pv.txt
	oc get pvc --all-namespaces -o wide  >> pvc.txt

	echo "---------- logging - Start "
	ansible-playbook -i inventario_v4 /usr/share/ansible/openshift-ansible/playbooks/openshift-logging/config.yml
	echo "---------- logging - Finish "
	
	sleep 120
	echo "---------- logging"            >> pods.txt
	echo "---------- logging"            >> pv.txt
	echo "---------- logging"            >> pvc.txt
	oc get pods --all-namespaces -o wide >> pods.txt
	oc get pv --all-namespaces -o wide   >> pv.txt
	oc get pvc --all-namespaces -o wide  >> pvc.txt
	
}

time install
