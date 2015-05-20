#
# Cookbook Name:: mcollective
# Attributes:: default
#
# Copyright 2011, Zachary Stevens
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# MCollective users - usernames in this array will be added to the
# mcollective group, which is permitted to read required config files.
default['mcollective']['users'] = []

# Chef Integration - these options control whether to install an
# MCollective agent (for controlling Chef), and Chef handlers to
# expose data about the node to mco.  Disable these if you don't want
# this functionality, or are installing it another way.
default['mcollective']['install_chef_agent?'] = true
default['mcollective']['install_chef_handler?'] = true
default['mcollective']['install_chef_application?'] = true

# Name of the mcollective group
default['mcollective']['group'] = 'mcollective'
default['mcollective']['create_group?'] = true

# Specify a version to install, or leave nil for latest
default['mcollective']['package']['version'] = nil
default['mcollective']['stomp_gem']['version'] = nil

# Security provider plugin - psk/ssl/aes_security
default['mcollective']['securityprovider'] = "psk"

# The key for the psk security provider
default['mcollective']['psk'] = "unset"
# PSK callertype can be: uid, username, gid, group, or identity
default['mcollective']['psk_callertype'] = "uid"

# Connector plugin - activemq/rabbitmq/stomp/redis
default['mcollective']['connector']         = "activemq"

# Use direct addressing?  Not supported on all connector plugins
# (see the MCollective documentation)
default['mcollective']['direct_addressing'] = "y"

# MCollective Identity and collective membership
default['mcollective']['identity']        = node['fqdn']
default['mcollective']['main_collective'] = "mcollective"
default['mcollective']['collectives']     = [
    'mcollective'
]

# Logging
# types are 'file' or 'syslog'
default['mcollective']['server']['logger_type'] = "file"
default['mcollective']['server']['syslog_facility'] = "daemon"
default['mcollective']['server']['logfile'] = "/var/log/mcollective.log"
default['mcollective']['server']['loglevel'] = "info"
default['mcollective']['server']['keeplogs'] = 5
default['mcollective']['server']['max_log_size'] = nil
default['mcollective']['client']['logger_type'] = "console"
default['mcollective']['client']['loglevel'] = "info"

# Locations
default['mcollective']['site_plugins'] = "/etc/mcollective/site_plugins/mcollective"
default['mcollective']['plugin_conf'] = "/etc/mcollective/plugin.d"

# Fact Source
# The default option configures MCollective to read a YAML file
# produced by a Chef handler, containing a configurable list of
# facts.  This gives the best MCollective performance, at the cost of
# less fresh data (updated only as frequently as you run Chef).
#
# Set this to 'ohai' to instead use the opscodeohai MCollective Fact
# plugin.
default['mcollective']['factsource']    = 'yaml'
default['mcollective']['yaml_factfile'] = '/etc/mcollective/facts.yaml'

default['mcollective']['classesfile']   = '/var/chef/cache/chef_recipes.txt'

# Ohai keys to include in the YAML fact list.
default['mcollective']['fact_whitelist'] = [
                                            'fqdn',
                                            'hostname',
                                            'domain',
                                            'ipaddress',
                                            'macaddress',
                                            'os',
                                            'os_version',
                                            'platform',
                                            'platform_version',
                                            'ohai_time',
                                            'uptime',
                                            'uptime_seconds',
                                            'chef_packages',
                                            'keys',
                                            'virtualization',
                                            'cpu',
                                            'memory'
                                           ]

# MCollective plugin location (created by the packages)
case platform_family
when "debian"
  default['mcollective']['libdir'] = "/usr/share/mcollective/plugins"
when "rhel","fedora"
  default['mcollective']['libdir'] = "/usr/libexec/mcollective"
end

## Cookbook plumbing
# Recipe used to install common components
default['mcollective']['recipes']['install_common'] = 'mcollective::_install_common_pkg'
# Recipe used to install server components
default['mcollective']['recipes']['install_server'] = 'mcollective::_install_server_pkg'
# Recipe used to install client components
default['mcollective']['recipes']['install_client'] = 'mcollective::_install_client_pkg'
# Whether to enable the puppetlabs apt/yum repo when installing from packages.
default['mcollective']['add_puppetlabs_repo'] = true
default['mcollective']['enable_puppetlabs_repo'] = false

# Set package options to enable puppet repo
if node['platform_family'] == 'rhel' && node['mcollective']['add_puppetlabs_repo']
  default['mcollective']['package']['options'] = '--assumeyes --enablerepo=puppetlabs --enablerepo=puppetlabs-deps'
else
  default['mcollective']['package']['options'] = '--assumeyes'
end
