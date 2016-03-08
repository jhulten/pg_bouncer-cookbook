default['pg_bouncer']['upgrade'] = true
default['pg_bouncer']['version'] = nil
default['pg_bouncer']['user'] = 'pgbouncer'
default['pg_bouncer']['group'] = 'pgbouncer'

instance_defaults = {
  databases: {},
  userlist: {},
  auth_type: 'md5',
  listen_addr: node['ipaddress'],
  listen_port: '6432',
  log_dir: '/var/log/pgbouncer',
  socket_dir: '/etc/pgbouncer/db_sockets',
  pid_dir: '/var/run/pgbouncer',
  admin_users: ['pgbouncer_admin'],
  stats_users: ['pgbouncer_monitor'],
  pool_mode: 'transaction',
  server_reset_query: 'DISCARD ALL;',
  max_client_conn: 60,
  default_pool_size: 30,
  min_pool_size: 10,
  reserve_pool_size: 5,
  server_idle_timeout: 3600,
  server_round_robin: 1,
  connect_query: '',
  tcp_keepalive: nil,
  tcp_keepidle: nil,
  tcp_keepintvl: nil,
  soft_limit: 65_000,
  hard_limit: 65_000,
  rotate_logs: true,
  service_state: [:enable, :start],
  additional: {}
}

default['pg_bouncer']['instance_defaults'] = instance_defaults
default['pg_bouncer']['instances'] = {}
