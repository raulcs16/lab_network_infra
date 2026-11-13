BASHTON := ssh console-server -c

ANSIBLE := "cd /lab_network_infra/ansible"
PLAYBOOK :=git-latest.yml

ex-config:
	$(BASHTON) "ansible-config init --disabled > example.cfg"
cat-config:
	$(BASHTON) "cat example.cfg"
run-play:
	$(BASHTON) $(ANSIBLE) && ansible-playbooks playbooks/$(PLAYBOOK)

.PHONY: ex-config cat-config run-play
