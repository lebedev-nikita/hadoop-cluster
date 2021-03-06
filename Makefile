_test:
# Следующие строки кода написаны на языке Make, а не Bash.
# Если добавить отступы слева от них, то утилита Make 
# будет интерпретировать их как код на Bash (а нам это не нужно).
ifndef ANSIBLE_MODE
	$(error ENV VARIABLE "ANSIBLE_MODE" IS NOT DEFINED)
endif
ifndef ANSIBLE_INVENTORY
	$(error ENV VARIABLE "ANSIBLE_INVENTORY" IS NOT DEFINED)
endif
ifeq ("$(wildcard inventory.$(ANSIBLE_MODE))", "")
	$(error FILE "inventory.$(ANSIBLE_MODE)" DOES NOT EXIST")
endif
ifeq ("$(wildcard inventory.$(ANSIBLE_MODE).password)", "")
	$(error FILE "inventory.$(ANSIBLE_MODE).password" DOES NOT EXIST")
endif
ifeq ("$(wildcard inventory.$(ANSIBLE_MODE).ports)", "")
	$(error FILE "inventory.$(ANSIBLE_MODE).ports" DOES NOT EXIST")
endif

init: _test
	ansible-playbook _init_hosts.yml && \
	ansible-playbook _download.yml && \
	ansible-playbook _configure.yml

start: _test
	ansible-playbook _start.yml

stop: _test
	ansible-playbook _stop.yml

configure: _test
	ansible-playbook _configure.yml

refresh_queues: _test
	ansible-playbook _configure.yml -e '{ "services": ["hadoop"] }' && \
	ansible-playbook _refresh_queues.yml

reinit: stop init start
reconfigure: stop configure start

DANGROUS_start_with_formatting: _test
	ansible-playbook _start.yml -e '{ "need_format": true }'

reformat_DANGEROUS: stop
	ansible-playbook _clean_data_DANGEROUS.yml && \
	ansible-playbook _configure.yml && \
	ansible-playbook _start.yml -e '{ "need_format": true }'
