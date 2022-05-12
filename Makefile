init: 
	ansible-playbook -i inventory.ini _init_hosts.yml && \
	ansible-playbook -i inventory.ini _download.yml && \
	ansible-playbook -i inventory.ini _configure.yml && \
	ansible-playbook -i inventory.ini _start.yml -e '{ need_format: true }'

start:
	ansible-playbook -i inventory.ini _start.yml

stop:
	ansible-playbook -i inventory.ini _stop.yml

configure:
	ansible-playbook -i inventory.ini _configure.yml

clean: stop
	ansible-playbook -i inventory.ini clean.yml
