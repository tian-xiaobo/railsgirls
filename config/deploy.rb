set :application, 'rails'
set :scm, :git
set :repo_url, "git@github.com:tian-xiaobo/railsgirls.git"
set :deploy_to, "/srv/apps/rails"
set :rails_env, 'production'
set :unicorn_rack_env, 'production'
set :ssh_options, { keys: %w{~/.ssh/id_rsa}, forward_agent: true, auth_methods: %w(publickey) }

set :format, :pretty
set :log_level, :debug

set :linked_files, %w{config/database.yml config/secrets.yml}

set :linked_dirs, %w{log tmp/pids tmp/logs tmp/cache tmp/sockets public/uploads}

set :keep_releases, 5

namespace :deploy do

  desc "serurely manages database config file after deploy"
  task :setup do
    on roles(:web) do |host|
      execute  "sudo gem install bundle"
      execute :mkdir, "-p #{deploy_to}/shared/config"
      execute :mkdir, "-p #{deploy_to}/shared/deploy"
      upload! "config/database.yml", "#{deploy_to}/shared/config/database.yml"
      upload! "config/secrets.yml", "#{deploy_to}/shared/config/secrets.yml"
    end
  end

  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      #execute :touch, release_path.join("tmp/restart.txt")
      invoke 'unicorn:restart'
    end
  end

  desc "reload the database with seed data"
  task :seed do
    on roles(fetch(:migration_role)) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:seed"
        end
      end
    end
  end

  after "deploy:migrate", "deploy:updated"
end

