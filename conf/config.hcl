# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: BUSL-1.1

# Full configuration options can be found at https://developer.hashicorp.com/vault/docs/configuration

ui = true

disable_mlock = true
cluster_addr  = "https://{{item}}:8201"
api_addr      = "https://{{item}}:8200"

# HTTPS listener
listener "tcp" {
  address       = "0.0.0.0:8200"
  tls_cert_file = "/opt/vault/ssl/{{item}}.crt"
  tls_key_file  = "/opt/vault/ssl/{{item}}.key"
  tls_client_ca_file = "/opt/vault/ssl/vault-ca.crt"
  x_forwarded_for_authorized_addrs = "{{hostvars['load-balancer'].internal_ip}}"
}

storage "raft" {
  path = "/opt/vault/data"
  node_id = "{{hostvars[item].node_id}}"

{% for host in groups['vault_cluster'] %}
  retry_join {
    leader_tls_servername   = "{{host}}"
    leader_api_addr         = "https://{{host}}:8200"
    leader_ca_cert_file     = "/opt/vault/ssl/vault-ca.crt"
    leader_client_cert_file = "/opt/vault/ssl/{{item}}.crt"
    leader_client_key_file  = "/opt/vault/ssl/{{item}}.key"
  }
{% endfor %}
}
