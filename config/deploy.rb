lock "~> 3.16.0"

server "167.172.162.161", port: 22, roles: %i[web app db], primary: true

set :rbenv_ruby, "2.7.2"

set :repo_url,        "git@github.com:zeddan/discogs-follow.git"
set :application,     "discogs-follow"
# set :website_url,     "robinsaaf.se/discogs-follow"
set :user,            "discogsfollow"
set :puma_threads,    [4, 16]
set :puma_workers,    0
set :enable_ssl,      true
set :ssl_certificate, "/etc/letsencrypt/live/robinsaaf.se/fullchain.pem;"
set :ssl_key,         "/etc/letsencrypt/live/robinsaaf.se/privkey.pem;"

set :linked_files, %w{config/master.key}
set :default_environment, {
  "RAILS_RELATIVE_URL_ROOT" => "/discogs-follow",
}

set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/code/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

namespace :puma do
  desc "Create Directories for Puma Pids and Socket"
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit # rubocop:disable Rails/Exit
      end
    end
  end

  desc "Initial Deploy"
  task :initial do
    on roles(:app) do
      before "deploy:restart", "puma:start"
      invoke "deploy"
    end
  end

  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke "puma:restart"
    end
  end

  before :starting,     :check_revision
end
