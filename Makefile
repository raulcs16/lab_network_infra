.PHONY: latest-play ping-all ping-gateway ping-apps ping-services cat-config

BASHTON := cd vagrant; vagrant ssh bashton -c


ex-config:
	$(BASHTON) "ansible-config init --disabled > example.cfg"
cat-config:
	$(BASHTON) "cat example.cfg"
cat-tasks:
	$(BASHTON) "cd ansible/roles/search/tasks && cat install.yml"
latest-play:
	$(BASHTON) "cd ansible && ansible-playbook playbooks/latest.yml"
set-net:
	$(BASHTON) "cd ansible && ansible-playbook playbooks/set_network.yml"
build-search:
	$(BASHTON) "cd ansible && ansible-playbook playbooks/build_search.yml"
ping-all:
	$(BASHTON) "cd ansible && ansible all -m ping"
ping-gateway:
	$(BASHTON) "cd ansible && ansible gateway -m ping"
ping-apps:
	$(BASHTON) "cd ansible && ansible apps -m ping"
ping-services:
	$(BASHTON) "cd ansible && ansible services -m ping"