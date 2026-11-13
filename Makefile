BASHTON := ssh console-server 

PLAYBOOK := git-latest.yml

ex-config:
	$(BASHTON) "ansible-config init --disabled > example.cfg"
cat-config:
	$(BASHTON) "cat example.cfg"
run-play:
	$(BASHTON) "cd ./lab_network_infra/ansible && ansible-playbook playbooks/$(PLAYBOOK)"

.PHONY: ex-config cat-config run-play
