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
#before "deploy:symlink", "deploy:package_assets"
#before "deploy:package_assets", "deploy:compile_css"
#before "deploy:migrate", "backup"


namespace :deploy do

  after "deploy:setup", "deploy:images:setup"
  #after "deploy:symlink", "deploy:images:symlink"

  namespace :images do
    desc "Create the images dir in shared path."
    task :setup do
      run "cd #{shared_path}; mkdir images"
    end

    desc "Link images from shared to common."
    task :symlink do
      run "cd #{current_path}/public; rm -rf images; ln -s #{shared_path}/images ."
    end
  end
  
#  desc "Build CSS through Less"
#  task :compile_css, :roles => [:app] do
#    run "cd #{release_path}; lessc #{release_path}/public/stylesheets/application.less"
#  end

#  desc "Package CSS and Javascripts"
#  task :package_assets, :roles => [:app] do
#    run "cd #{release_path}; rake asset:packager:build_all"
#  end
  
  desc "Run bundle install"
  task :bundle, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path}; bundle install"
  end

  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
  [:start, :stop].each do |t|
      desc "#{t} task is a no-op with mod_rails"
      task t, :roles => :app do ; end
    end
end



# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end