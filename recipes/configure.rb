#
# Cookbook Name:: pg_bouncer
# Recipe:: default
#
# The MIT License (MIT)
#
# Copyright (c) 2015 Jeffrey Hulten
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

log 'pg_bouncer instances hash is empty. No instances will be configured' do
  level :warn
  only_if { node['pg_bouncer']['instances'].empty? }
end

directory '/etc/pgbouncer' do
  action :create
  recursive true
  mode 0775
end

execute 'reload_systemd_manager' do
  command 'systemctl daemon-reload'
  action :nothing
end

node['pg_bouncer']['instances'].each do |name, inst|

  execute "enable pgbouncer-#{name}" do
    command "systemctl enable pgbouncer-#{name}@"
    action :nothing
  end

  # merge with instance_defaults
  inst = node['pg_bouncer']['instance_defaults'].merge(inst)

  # create the log, pid, and application socket directories
  %w(
    log_dir
    pid_dir
    socket_dir
  ).each do |dir|
    directory inst[dir] do
      action :create
      recursive true
      owner node['pg_bouncer']['user']
      group node['pg_bouncer']['group']
      mode 0775
    end
  end

  # build the userlist, pgbouncer.ini, upstart conf and logrotate.d templates
  {
    "/etc/pgbouncer/userlist-#{name}.txt" =>
    'etc/pgbouncer/userlist.txt.erb',
    "/etc/pgbouncer/pgbouncer-#{name}.ini" =>
    'etc/pgbouncer/pgbouncer.ini.erb',
    "/etc/systemd/system/pgbouncer-#{name}@.service" =>
    'etc/systemd/system/pgbouncer.service.erb'
  }.each do |key, source_template|
    template key.dup do
      source source_template
      owner node['pg_bouncer']['user']
      group node['pg_bouncer']['group']
      mode 0440
      notifies :run, "execute[reload pgbouncer-#{name}]"
      variables(name: name, 
                instance: inst,
                user: node['pg_bouncer']['user'],
                group: node['pg_bouncer']['group'])
    end
  end

  template "/etc/logrotate.d/pgbouncer-#{name}" do
    source 'etc/logrotate.d/pgbouncer-logrotate.d.erb'
    owner 'root'
    group 'root'
    mode 0644
    variables(name: name, instance: inst,
              user: node['pg_bouncer']['user'], group: node['pg_bouncer']['group'])
    notifies :run, resources(:execute => [ 'reload_systemd_manager' ])
    notifies :run, resources(:execute => [ "enable pgbouncer-#{name}" ])
  end

  execute "reload pgbouncer-#{name}" do # ~FC004
    command "service pgbouncer-#{name}@0 reload || service pgbouncer-#{name}@0 start"
    user 'root'
    action :nothing
    only_if { ::File.exist?("/etc/pgbouncer/pgbouncer-#{name}.ini") }
  end

  service "pgbouncer-#{name}@0" do
    supports enable: true, start: true, restart: true, reload: true
    action inst['service_state']
  end
end
