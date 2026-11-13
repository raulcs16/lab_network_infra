BASHTON := ssh console-server 

PLAYBOOK := git-latest.yml
DEBUG := False

ex-config:
	$(BASHTON) "ansible-config init --disabled > example.cfg"
cat-config:
	$(BASHTON) "cat example.cfg"
run-play:
	$(BASHTON) "cd ./lab_network_infra/ansible && ANSIBLE_DEBUG=$(DEBUG) ansible-playbook playbooks/$(PLAYBOOK)"

.PHONY: ex-config cat-config run-play
