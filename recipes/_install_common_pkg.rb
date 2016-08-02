#
# Cookbook Name:: mcollective
# Recipe:: install_common_pkg
#
# Installs mcollective-common using packages.
#
# Copyright 2013, Zachary Stevens
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

if node['mcollective']['add_puppetlabs_repo'] || node['mcollective']['enable_puppetlabs_repo']
  include_recipe 'mcollective::puppetlabs-repo'
end

package "rubygems" do
  action :install
end

package "rubygem-stomp" do
  case node['platform_family']
  when "debian"
    package_name "libstomp-ruby"
  when "rhel","fedora"
    package_name "rubygem-stomp"
    options node['mcollective']['package']['options']
  end
  action :install
end

pp node['mcollective']

package "mcollective-common" do
  action :install
  version node['mcollective']['package']['version']
  options node['mcollective']['package']['options']
end

if node['platform'] == 'amazon'
  link '/usr/local/share/ruby/site_ruby/2.0/mcollective' do
    to '/usr/lib/ruby/site_ruby/1.8/mcollective'
  end
  link '/usr/local/share/ruby/site_ruby/2.0/mcollective.rb' do
    to '/usr/lib/ruby/site_ruby/1.8/mcollective.rb'
  end
  gem_package 'stomp' do
    action  :install
    version node['mcollective']['stomp_gem']['version']
  end
end
