provider "aws" {
  # profile = "default"
  region = var.region
}

data "aws_security_group" "default" {
  name = "default"
  #   vpc_id = module.vpc.vpc_id
  vpc_id = local.vpc_id
}

locals {
  vpc_id = "vpc-04bc8955784f0fa6d"
  vpc_cidr_block = "10.0.0.0/16"
}

module "web_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"
  
  name        = "web-server"
  description = "${var.name} Security group for web-server"

  #   vpc_id      = "${module.vpc.vpc_id}"
  vpc_id = local.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]

  tags = var.tags
}

module "custom_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "custom"
  description = "${var.name} Security group for custom ports"
  vpc_id      = local.vpc_id


  # https
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp"]


  # custom port & postgresql
  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8090
      protocol    = "tcp"
      description = "Custom ports"
      cidr_blocks = local.vpc_cidr_block
    },
    {
      rule        = "postgresql-tcp"
      cidr_blocks = local.vpc_cidr_block
    },
  ]
}


module "mysql_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "mysql"
  description = "${var.name} Security group for mysql ports"
  vpc_id      = local.vpc_id


  # https
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["mysql-tcp"]


  # custom port & postgresql
  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8090
      protocol    = "tcp"
      description = "Custom ports"
      cidr_blocks = local.vpc_cidr_block
    },
    {
      rule        = "postgresql-tcp"
      cidr_blocks = local.vpc_cidr_block
    },
  ]
}

# module "db_computed_source_sg" {
#   source = "terraform-aws-modules/security-group/aws"

#   name        = "db_computed_source_sg"
#   description = "${var.name} Security group for db_computed_source_sg"

#   vpc_id = local.vpc_id # these are valid values also - "${module.vpc.vpc_id}" and "${local.vpc_id}"

#   computed_ingress_with_source_security_group_id = [
#     {
#       rule                     = "mysql-tcp"
#       source_security_group_id = "${module.web_sg.this_security_group_id}"
#     }
#   ]
#   number_of_computed_ingress_with_source_security_group_id = 1
# }

# module "db_computed_sg" {
#   source = "terraform-aws-modules/security-group/aws"

#   name        = "db_computed_sg"
#   description = "${var.name} Security group for db_computed_sg"

#   vpc_id = "vpc-04bc8955784f0fa6d" # these are valid values also - "${module.vpc.vpc_id}" and "${local.vpc_id}"


#   ingress_cidr_blocks = ["10.0.0.0/16", "${data.aws_security_group.default.id}"]

#   computed_ingress_cidr_blocks           = ["${module.vpc.vpc_cidr_block}"]
#   number_of_computed_ingress_cidr_blocks = 1
# }

# module "db_computed_merged_sg" {
#   # omitted for brevity

#   computed_ingress_cidr_blocks = ["10.10.0.0/16", "${module.vpc.vpc_cidr_block}"]
#   number_of_computed_ingress_cidr_blocks = 2
# }




#####################
##### [ rules ] #####
#####################
#
# {
#   "_": [
#     "",
#     "",
#     ""
#   ],
#   "activemq-5671-tcp": [
#     5671,
#     5671,
#     "tcp",
#     "ActiveMQ AMQP"
#   ],
#   "activemq-61614-tcp": [
#     61614,
#     61614,
#     "tcp",
#     "ActiveMQ STOMP"
#   ],
#   "activemq-61617-tcp": [
#     61617,
#     61617,
#     "tcp",
#     "ActiveMQ OpenWire"
#   ],
#   "activemq-61619-tcp": [
#     61619,
#     61619,
#     "tcp",
#     "ActiveMQ WebSocket"
#   ],
#   "activemq-8883-tcp": [
#     8883,
#     8883,
#     "tcp",
#     "ActiveMQ MQTT"
#   ],
#   "alertmanager-9093-tcp": [
#     9093,
#     9093,
#     "tcp",
#     "Alert Manager"
#   ],
#   "alertmanager-9094-tcp": [
#     9094,
#     9094,
#     "tcp",
#     "Alert Manager Cluster"
#   ],
#   "all-all": [
#     -1,
#     -1,
#     "-1",
#     "All protocols"
#   ],
#   "all-icmp": [
#     -1,
#     -1,
#     "icmp",
#     "All IPV4 ICMP"
#   ],
#   "all-ipv6-icmp": [
#     -1,
#     -1,
#     58,
#     "All IPV6 ICMP"
#   ],
#   "all-tcp": [
#     0,
#     65535,
#     "tcp",
#     "All TCP ports"
#   ],
#   "all-udp": [
#     0,
#     65535,
#     "udp",
#     "All UDP ports"
#   ],
#   "carbon-admin-tcp": [
#     2004,
#     2004,
#     "tcp",
#     "Carbon admin"
#   ],
#   "carbon-gui-udp": [
#     8081,
#     8081,
#     "tcp",
#     "Carbon GUI"
#   ],
#   "carbon-line-in-tcp": [
#     2003,
#     2003,
#     "tcp",
#     "Carbon line-in"
#   ],
#   "carbon-line-in-udp": [
#     2003,
#     2003,
#     "udp",
#     "Carbon line-in"
#   ],
#   "carbon-pickle-tcp": [
#     2013,
#     2013,
#     "tcp",
#     "Carbon pickle"
#   ],
#   "carbon-pickle-udp": [
#     2013,
#     2013,
#     "udp",
#     "Carbon pickle"
#   ],
#   "cassandra-clients-tcp": [
#     9042,
#     9042,
#     "tcp",
#     "Cassandra clients"
#   ],
#   "cassandra-jmx-tcp": [
#     7199,
#     7199,
#     "tcp",
#     "JMX"
#   ],
#   "cassandra-thrift-clients-tcp": [
#     9160,
#     9160,
#     "tcp",
#     "Cassandra Thrift clients"
#   ],
#   "consul-cli-rpc-tcp": [
#     8400,
#     8400,
#     "tcp",
#     "Consul CLI RPC"
#   ],
#   "consul-dns-tcp": [
#     8600,
#     8600,
#     "tcp",
#     "Consul DNS"
#   ],
#   "consul-dns-udp": [
#     8600,
#     8600,
#     "udp",
#     "Consul DNS"
#   ],
#   "consul-serf-lan-tcp": [
#     8301,
#     8301,
#     "tcp",
#     "Serf LAN"
#   ],
#   "consul-serf-lan-udp": [
#     8301,
#     8301,
#     "udp",
#     "Serf LAN"
#   ],
#   "consul-serf-wan-tcp": [
#     8302,
#     8302,
#     "tcp",
#     "Serf WAN"
#   ],
#   "consul-serf-wan-udp": [
#     8302,
#     8302,
#     "udp",
#     "Serf WAN"
#   ],
#   "consul-tcp": [
#     8300,
#     8300,
#     "tcp",
#     "Consul server"
#   ],
#   "consul-webui-tcp": [
#     8500,
#     8500,
#     "tcp",
#     "Consul web UI"
#   ],
#   "dns-tcp": [
#     53,
#     53,
#     "tcp",
#     "DNS"
#   ],
#   "dns-udp": [
#     53,
#     53,
#     "udp",
#     "DNS"
#   ],
#   "docker-swarm-mngmt-tcp": [
#     2377,
#     2377,
#     "tcp",
#     "Docker Swarm cluster management"
#   ],
#   "docker-swarm-node-tcp": [
#     7946,
#     7946,
#     "tcp",
#     "Docker Swarm node"
#   ],
#   "docker-swarm-node-udp": [
#     7946,
#     7946,
#     "udp",
#     "Docker Swarm node"
#   ],
#   "docker-swarm-overlay-udp": [
#     4789,
#     4789,
#     "udp",
#     "Docker Swarm Overlay Network Traffic"
#   ],
#   "elasticsearch-java-tcp": [
#     9300,
#     9300,
#     "tcp",
#     "Elasticsearch Java interface"
#   ],
#   "elasticsearch-rest-tcp": [
#     9200,
#     9200,
#     "tcp",
#     "Elasticsearch REST interface"
#   ],
#   "grafana-tcp": [
#     3000,
#     3000,
#     "tcp",
#     "Grafana Dashboard"
#   ],
#   "graphite-2003-tcp": [
#     2003,
#     2003,
#     "tcp",
#     "Carbon receiver plain text"
#   ],
#   "graphite-2004-tcp": [
#     2004,
#     2004,
#     "tcp",
#     "Carbon receiver pickle"
#   ],
#   "graphite-2023-tcp": [
#     2023,
#     2023,
#     "tcp",
#     "Carbon aggregator plaintext"
#   ],
#   "graphite-2024-tcp": [
#     2024,
#     2024,
#     "tcp",
#     "Carbon aggregator pickle"
#   ],
#   "graphite-8080-tcp": [
#     8080,
#     8080,
#     "tcp",
#     "Graphite gunicorn port"
#   ],
#   "graphite-8125-tcp": [
#     8125,
#     8125,
#     "tcp",
#     "Statsd TCP"
#   ],
#   "graphite-8125-udp": [
#     8125,
#     8125,
#     "udp",
#     "Statsd UDP default"
#   ],
#   "graphite-8126-tcp": [
#     8126,
#     8126,
#     "tcp",
#     "Statsd admin"
#   ],
#   "graphite-webui": [
#     80,
#     80,
#     "tcp",
#     "Graphite admin interface"
#   ],
#   "http-80-tcp": [
#     80,
#     80,
#     "tcp",
#     "HTTP"
#   ],
#   "http-8080-tcp": [
#     8080,
#     8080,
#     "tcp",
#     "HTTP"
#   ],
#   "https-443-tcp": [
#     443,
#     443,
#     "tcp",
#     "HTTPS"
#   ],
#   "https-8443-tcp": [
#     8443,
#     8443,
#     "tcp",
#     "HTTPS"
#   ],
#   "ipsec-4500-udp": [
#     4500,
#     4500,
#     "udp",
#     "IPSEC NAT-T"
#   ],
#   "ipsec-500-udp": [
#     500,
#     500,
#     "udp",
#     "IPSEC ISAKMP"
#   ],
#   "kafka-broker-tcp": [
#     9092,
#     9092,
#     "tcp",
#     "Kafka broker 0.8.2+"
#   ],
#   "kafka-broker-tls-tcp": [
#     9094,
#     9094,
#     "tcp",
#     "Kafka TLS enabled broker 0.8.2+"
#   ],
#   "kafka-jmx-exporter-tcp": [
#     11001,
#     11001,
#     "tcp",
#     "Kafka JMX Exporter"
#   ],
#   "kafka-node-exporter-tcp": [
#     11002,
#     11002,
#     "tcp",
#     "Kafka Node Exporter"
#   ],
#   "kibana-tcp": [
#     5601,
#     5601,
#     "tcp",
#     "Kibana Web Interface"
#   ],
#   "kubernetes-api-tcp": [
#     6443,
#     6443,
#     "tcp",
#     "Kubernetes API Server"
#   ],
#   "ldap-tcp": [
#     389,
#     389,
#     "tcp",
#     "LDAP"
#   ],
#   "ldaps-tcp": [
#     636,
#     636,
#     "tcp",
#     "LDAPS"
#   ],
#   "logstash-tcp": [
#     5044,
#     5044,
#     "tcp",
#     "Logstash"
#   ],
#   "memcached-tcp": [
#     11211,
#     11211,
#     "tcp",
#     "Memcached"
#   ],
#   "minio-tcp": [
#     9000,
#     9000,
#     "tcp",
#     "MinIO"
#   ],
#   "mongodb-27017-tcp": [
#     27017,
#     27017,
#     "tcp",
#     "MongoDB"
#   ],
#   "mongodb-27018-tcp": [
#     27018,
#     27018,
#     "tcp",
#     "MongoDB shard"
#   ],
#   "mongodb-27019-tcp": [
#     27019,
#     27019,
#     "tcp",
#     "MongoDB config server"
#   ],
#   "mssql-analytics-tcp": [
#     2383,
#     2383,
#     "tcp",
#     "MSSQL Analytics"
#   ],
#   "mssql-broker-tcp": [
#     4022,
#     4022,
#     "tcp",
#     "MSSQL Broker"
#   ],
#   "mssql-tcp": [
#     1433,
#     1433,
#     "tcp",
#     "MSSQL Server"
#   ],
#   "mssql-udp": [
#     1434,
#     1434,
#     "udp",
#     "MSSQL Browser"
#   ],
#   "mysql-tcp": [
#     3306,
#     3306,
#     "tcp",
#     "MySQL/Aurora"
#   ],
#   "nfs-tcp": [
#     2049,
#     2049,
#     "tcp",
#     "NFS/EFS"
#   ],
#   "nomad-http-tcp": [
#     4646,
#     4646,
#     "tcp",
#     "Nomad HTTP"
#   ],
#   "nomad-rpc-tcp": [
#     4647,
#     4647,
#     "tcp",
#     "Nomad RPC"
#   ],
#   "nomad-serf-tcp": [
#     4648,
#     4648,
#     "tcp",
#     "Serf"
#   ],
#   "nomad-serf-udp": [
#     4648,
#     4648,
#     "udp",
#     "Serf"
#   ],
#   "ntp-udp": [
#     123,
#     123,
#     "udp",
#     "NTP"
#   ],
#   "openvpn-https-tcp": [
#     443,
#     443,
#     "tcp",
#     "OpenVPN"
#   ],
#   "openvpn-tcp": [
#     943,
#     943,
#     "tcp",
#     "OpenVPN"
#   ],
#   "openvpn-udp": [
#     1194,
#     1194,
#     "udp",
#     "OpenVPN"
#   ],
#   "oracle-db-tcp": [
#     1521,
#     1521,
#     "tcp",
#     "Oracle"
#   ],
#   "postgresql-tcp": [
#     5432,
#     5432,
#     "tcp",
#     "PostgreSQL"
#   ],
#   "prometheus-http-tcp": [
#     9090,
#     9090,
#     "tcp",
#     "Prometheus"
#   ],
#   "prometheus-pushgateway-http-tcp": [
#     9091,
#     9091,
#     "tcp",
#     "Prometheus Pushgateway"
#   ],
#   "puppet-tcp": [
#     8140,
#     8140,
#     "tcp",
#     "Puppet"
#   ],
#   "puppetdb-tcp": [
#     8081,
#     8081,
#     "tcp",
#     "PuppetDB"
#   ],
#   "rabbitmq-15672-tcp": [
#     15672,
#     15672,
#     "tcp",
#     "RabbitMQ"
#   ],
#   "rabbitmq-25672-tcp": [
#     25672,
#     25672,
#     "tcp",
#     "RabbitMQ"
#   ],
#   "rabbitmq-4369-tcp": [
#     4369,
#     4369,
#     "tcp",
#     "RabbitMQ epmd"
#   ],
#   "rabbitmq-5671-tcp": [
#     5671,
#     5671,
#     "tcp",
#     "RabbitMQ"
#   ],
#   "rabbitmq-5672-tcp": [
#     5672,
#     5672,
#     "tcp",
#     "RabbitMQ"
#   ],
#   "rdp-tcp": [
#     3389,
#     3389,
#     "tcp",
#     "Remote Desktop"
#   ],
#   "rdp-udp": [
#     3389,
#     3389,
#     "udp",
#     "Remote Desktop"
#   ],
#   "redis-tcp": [
#     6379,
#     6379,
#     "tcp",
#     "Redis"
#   ],
#   "redshift-tcp": [
#     5439,
#     5439,
#     "tcp",
#     "Redshift"
#   ],
#   "solr-tcp": [
#     8983,
#     8987,
#     "tcp",
#     "Solr"
#   ],
#   "splunk-hec-tcp": [
#     8088,
#     8088,
#     "tcp",
#     "Splunk HEC"
#   ],
#   "splunk-indexer-tcp": [
#     9997,
#     9997,
#     "tcp",
#     "Splunk indexer"
#   ],
#   "splunk-splunkd-tcp": [
#     8089,
#     8089,
#     "tcp",
#     "Splunkd"
#   ],
#   "splunk-web-tcp": [
#     8000,
#     8000,
#     "tcp",
#     "Splunk Web"
#   ],
#   "squid-proxy-tcp": [
#     3128,
#     3128,
#     "tcp",
#     "Squid default proxy"
#   ],
#   "ssh-tcp": [
#     22,
#     22,
#     "tcp",
#     "SSH"
#   ],
#   "storm-nimbus-tcp": [
#     6627,
#     6627,
#     "tcp",
#     "Nimbus"
#   ],
#   "storm-supervisor-tcp": [
#     6700,
#     6703,
#     "tcp",
#     "Supervisor"
#   ],
#   "storm-ui-tcp": [
#     8080,
#     8080,
#     "tcp",
#     "Storm UI"
#   ],
#   "web-jmx-tcp": [
#     1099,
#     1099,
#     "tcp",
#     "JMX"
#   ],
#   "winrm-http-tcp": [
#     5985,
#     5985,
#     "tcp",
#     "WinRM HTTP"
#   ],
#   "winrm-https-tcp": [
#     5986,
#     5986,
#     "tcp",
#     "WinRM HTTPS"
#   ],
#   "zipkin-admin-query-tcp": [
#     9901,
#     9901,
#     "tcp",
#     "Zipkin Admin port query"
#   ],
#   "zipkin-admin-tcp": [
#     9990,
#     9990,
#     "tcp",
#     "Zipkin Admin port collector"
#   ],
#   "zipkin-admin-web-tcp": [
#     9991,
#     9991,
#     "tcp",
#     "Zipkin Admin port web"
#   ],
#   "zipkin-query-tcp": [
#     9411,
#     9411,
#     "tcp",
#     "Zipkin query port"
#   ],
#   "zipkin-web-tcp": [
#     8080,
#     8080,
#     "tcp",
#     "Zipkin web port"
#   ],
#   "zookeeper-2181-tcp": [
#     2181,
#     2181,
#     "tcp",
#     "Zookeeper"
#   ],
#   "zookeeper-2888-tcp": [
#     2888,
#     2888,
#     "tcp",
#     "Zookeeper"
#   ],
#   "zookeeper-3888-tcp": [
#     3888,
#     3888,
#     "tcp",
#     "Zookeeper"
#   ],
#   "zookeeper-jmx-tcp": [
#     7199,
#     7199,
#     "tcp",
#     "JMX"
#   ]
# }