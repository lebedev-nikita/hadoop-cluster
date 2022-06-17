_test:
# Следующие строки кода написаны на языке Make, а не Bash.
# Если добавить отступы слева от них, то утилита Make 
# будет интерпретировать их как код на Bash (а нам это не нужно).
ifndef ANSIBLE_MODE
	$(error ENV VARIABLE "ANSIBLE_MODE" IS NOT DEFINED)
endif
ifndef INVENTORY
	$(error ENV VARIABLE "INVENTORY" IS NOT DEFINED)
endif
ifeq ("$(wildcard inventory.$(ANSIBLE_MODE).password)", "")
	$(error FILE "inventory.$(ANSIBLE_MODE).password" DOES NOT EXIST")
endif

init: _test
	ansible-playbook $(INVENTORY) _init_hosts.yml && \
	ansible-playbook $(INVENTORY) _download.yml && \
	ansible-playbook $(INVENTORY) _configure.yml

start: _test
	ansible-playbook $(INVENTORY) _start.yml

stop: _test
	ansible-playbook $(INVENTORY) _stop.yml

refresh_queues: _test
	ansible-playbook $(INVENTORY) _configure.yml -e '{ "services": ["hadoop"] }' && \
	ansible-playbook $(INVENTORY) _refresh_queues.yml

start_with_formatting_DANGEROUS: _test
	ansible-playbook $(INVENTORY) _start.yml -e '{ "need_format": true }'

restart_DANGEROUS: stop
	ansible-playbook $(INVENTORY) _dangerous_clean_data.yml
	ansible-playbook $(INVENTORY) _configure.yml
	ansible-playbook $(INVENTORY) _start.yml -e '{ "need_format": true }'
