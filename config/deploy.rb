set :stages, %w(qa production)
set :default_stage, "qa"

require 'capistrano/ext/multistage'
require 'bundler/capistrano'

set :user, 'bookdrive'
set :domain, 'richmondbookdrive.com'
set :application, "bookdrive"

set :scm, :git
set :scm_verbose, true
set :use_sudo, false

set :repository,  "/home/#{user}/git/#{application}.git"
set :local_repository,  "ssh://#{user}@#{domain}:2288/~/git/#{application}.git"
set :port, 2288
set :stack, :passenger_apache

ssh_options[:username] = "bookdrive"
ssh_options[:keys] = %w(~/.ssh/id_dsa)
ssh_options[:auth_methods] = ["publickey"]
ssh_options[:port] = 2288
ssh_options[:forward_agent] = true
ssh_options[:paranoid] = false

default_run_options[:pty] = true

role :web, domain, :port => 2288                          # Your HTTP server, Apache/etc
role :app, domain, :port => 2288                          # This may be the same as your `Web` server
role :db,  domain, :port => 2288, :primary => true # This is where Rails migrations will run
#role :db,  "bookdrive"


desc "Tail remote logs"
task :tail_log, :roles => :app do
  stream "tail -f #{shared_path}/log/#{stage}.log"
end


before "deploy", "deploy:web:disable"
after "deploy", "deploy:web:enable"

namespace :deploy do
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
    
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
