
BASHTON := ssh console-server 

PLAYBOOK := git-latest.yml
DEBUG := False
CHECK ?= false

# Translate the boolean into the actual Ansible flag
ifeq ($(CHECK),true)
CHECK_FLAG := --check
else
CHECK_FLAG :=
endif

ex-config:
	$(BASHTON) "ansible-config init --disabled > example.cfg"
cat-config:
	$(BASHTON) "cat example.cfg"

verify-ssh:
	$(BASHTON) "cd ./lab_network_infra/ansible && ansible all -m ios_command -a \"commands='show version | include uptime'\" "

show-plays:
	$(BASHTON) "ls ./lab_network_infra/ansible/playbooks"
run-play:
	$(BASHTON) "cd ./lab_network_infra/ansible && ANSIBLE_DEBUG=$(DEBUG) ansible-playbook playbooks/$(PLAYBOOK) $(CHECK_FLAG)" 


.PHONY: ex-config cat-config run-play show-config
