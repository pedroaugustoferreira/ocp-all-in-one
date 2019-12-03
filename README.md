# ocp-all-in-one

  
Ordem de execução:
'# ansible-playbook -i inventario /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml 
'# ansible-playbook -i inventario /usr/share/ansible/openshift-ansible/playbooks/openshift-monitoring/config.yml 
'# ansible-playbook -i inventario /usr/share/ansible/openshift-ansible/playbooks/metrics-server/config.yml 
'# ansible-playbook -i inventario /usr/share/ansible/openshift-ansible/playbooks/openshift-metrics/config.yml 
'# ansible-playbook -i inventario /usr/share/ansible/openshift-ansible/playbooks/openshift-logging/config.yml 



Depois de rodar a parte do monitoring todos os pods são recriados do projetos openshift-monitoring 

As metricas no grafana ja aparecem

