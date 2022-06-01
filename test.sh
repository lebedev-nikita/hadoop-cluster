ansible-playbook _init_hosts.yml &&
ansible-playbook _download.yml -e '{ "services": ["airflow"] }' &&
ansible-playbook _configure.yml -e '{ "services": ["airflow"] }' &&
ansible-playbook _start.yml -e '{ "need_format": true, "services": ["airflow"] }' &&
true
