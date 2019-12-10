#!/bin/bash

install()
{
#	ansible-playbook -i inventario /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml;

	echo "---------- deploy_cluster - Start "
	ansible-playbook -i inventario_v1 /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml;
	echo "---------- deploy_cluster - Finish"

	sleep 120
	echo "-- deploy_cluster"      > pods.log
	oc get pods --all-namespaces >> pods.log
	
	echo "---------- openshift-monitoring - Start"
	ansible-playbook -i inventario_v2 /usr/share/ansible/openshift-ansible/playbooks/openshift-monitoring/config.yml 
	echo "---------- openshift-monitoring - Finish "

        sleep 120
        echo "-- openshift-monitoring" >> pods.log
        oc get pods --all-namespaces   >> pods.log

	echo "---------- metrics-server - Start"
	ansible-playbook -i inventario_v3 /usr/share/ansible/openshift-ansible/playbooks/metrics-server/config.yml
        echo "---------- metrics-server - Finish "

        sleep 120
        echo "-- metrics-server"      >> pods.log
        oc get pods --all-namespaces  >> pods.log

	echo "---------- openshift-metrics - Start "
	ansible-playbook -i inventario_v3 /usr/share/ansible/openshift-ansible/playbooks/openshift-metrics/config.yml
        echo "---------- openshift-metrics - Finish "

        sleep 120
        echo "-- openshift-metrics"   >> pods.log
        oc get pods --all-namespaces  >> pods.log

	echo "---------- openshift-logging - Start "
	ansible-playbook -i inventario_v4 /usr/share/ansible/openshift-ansible/playbooks/openshift-logging/config.yml
	echo "---------- openshift-logging - Finish "

        echo "-- openshift-logging"   >> pods.log
        oc get pods --all-namespaces  >> pods.log
	
	
}

time install
