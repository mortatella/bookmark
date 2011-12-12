set :application, "Bookmakr"
set :repository,  "git@github.com:mortatella/bookmark.git"

set :deploy_to, "/var/www/virthosts/redpill.mediacube.at"
set :user, "deploy_redpill"
set :use_sudo, false

set :scm, :git
set :branch, "master"
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
default_environment["LANG"] = "en_US.UTF-8"
set :port, 5412

role :web, "mediacube.at"
role :app, "mediacube.at"
role :db,  "mediacube.at", :primary => true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :copy_config do
    #run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

require "bundler/capistrano"

load 'deploy/assets'

after "deploy:update_code", "deploy:copy_config"