#!/bin/bash -l
source /etc/environment
sleep 5
vault operator unseal {{hostvars['vault1']['vault_init_data']['stdout_lines'][0][14:]}}
sleep 5
vault operator unseal {{hostvars['vault1']['vault_init_data']['stdout_lines'][1][14:]}}
sleep 5
vault operator unseal {{hostvars['vault1']['vault_init_data']['stdout_lines'][2][14:]}}
sleep 5
