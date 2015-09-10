#set :branch, 'staging'
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :user, 'vagrant'
set :use_sudo, true
set :ssh_options, { keys: %w{~/.ssh/id_rsa}, forward_agent: true, port: 2222, auth_methods: %w(publickey) }
set :default_env, { path: "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH" }
server 'localhost', user: 'vagrant', roles: %w[web app db], primary: true #, sidekiq: true, whenever: true
