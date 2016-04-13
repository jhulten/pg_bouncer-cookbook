name 'pg_bouncer'
maintainer 'Jeffrey Hulten'
maintainer_email 'jhulten@gmail.com'
license 'Apache v2.0'
description 'Installs/Configures pg_bouncer'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.1.1'

source_url 'https://github.com/jhulten/pg_bouncer-cookbook'
issues_url 'https://github.com/jhulten/pg_bouncer-cookbook/issues'

supports 'ubuntu', '>= 12.04'

recipe 'pg_bouncer::default', 'Install and configure pgbouncer'
recipe 'pg_bouncer::install', 'Install pgbouncer'
recipe 'pg_bouncer::configure', 'Configure pgbouncer'

attribute 'pg_bouncer/upgrade',
          display_name: 'Auto-Upgrade',
          description: 'Should the pgbouncer package be upgraded',
          type: 'boolean',
          recipes: ['pg_bouncer::install'],
          default: true
attribute 'pg_bouncer/version',
          display_name: 'PGBouncer Version',
          description: 'Version of the pgbouncer package',
          type: 'string',
          recipes: ['pg_bouncer::install'],
          default: nil
attribute 'pg_bouncer/user',
          display_name: 'Username',
          description: 'User for pgbouncer processes and files',
          type: 'string',
          recipes: ['pg_bouncer::install'],
          default: 'pgbouncer'
attribute 'pg_bouncer/group',
          display_name: 'Group Name',
          description: 'Group for the pgbouncer user',
          type: 'string',
          recipes: ['pg_bouncer::install'],
          default: true
attribute 'pg_bouncer/instance_defaults',
          display_name: 'Instance Defaults',
          description: 'Default settings for instances',
          type: 'hash',
          recipes: ['pg_bouncer::configure']
attribute 'pg_bouncer/instances',
          display_name: 'Instances',
          description: 'Hash of instance names and configuration',
          type: 'hash',
          recipes: ['pg_bouncer::configure'],
          default: {}
