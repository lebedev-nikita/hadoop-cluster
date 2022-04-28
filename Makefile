init: 
	ansible-playbook --ask-become-pass -i inventory.ini start.yml \
		-e '{ need_format: true }'

start:
	ansible-playbook --ask-become-pass -i inventory.ini start.yml

stop:
	ansible-playbook --ask-become-pass -i inventory.ini stop.yml

clean:
	ansible-playbook --ask-become-pass -i inventory.ini clean.yml
