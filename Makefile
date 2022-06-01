init:
	ansible-playbook _init_hosts.yml && \
	ansible-playbook _download.yml && \
	ansible-playbook _configure.yml

start:
	ansible-playbook _start.yml

stop:
	ansible-playbook _stop.yml

refresh_queues:
	ansible-playbook _configure.yml -e '{ "services": ["hadoop"] }' && \
	ansible-playbook _refresh_queues.yml

dangerous_start_with_formatting: 
	ansible-playbook _start.yml -e '{ "need_format": true }'

restart: stop
	ansible-playbook _dangerous_clean_data.yml
	ansible-playbook _configure.yml
	ansible-playbook _start.yml -e '{ "need_format": true }'
