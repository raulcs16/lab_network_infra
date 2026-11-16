
BASHTON := ssh console-server 

PLAY := git-latest.yml
CHECKPLAY := configure-network.yml
DEBUG := False

ex-config:
	$(BASHTON) "ansible-config init --disabled > example.cfg"
cat-config:
	$(BASHTON) "cat example.cfg"

verify-ssh:
	$(BASHTON) "cd ./lab_network_infra/ansible && ansible all -m ios_command -a \"commands='show version | include uptime'\" "

show-plays:
	$(BASHTON) "ls ./lab_network_infra/ansible/playbooks"
run-play:
	$(BASHTON) "cd ./lab_network_infra/ansible && ANSIBLE_DEBUG=$(DEBUG) ansible-playbook playbooks/$(PLAY) $(CHECK_FLAG)" 
check-play:
	$(BASHTON) "cd ./lab_network_infra/ansible && ANSIBLE_DEBUG=$(DEBUG) ansible-playbook playbooks/$(CHECKPLAY) --check" 



.PHONY: ex-config cat-config run-play check-play show-config
