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


$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, 'ruby-1.9.2-p0'        # Or whatever env you want it to run in.
set :rvm_type, :user

desc "Tail remote logs"
task :tail_log, :roles => :app do
  stream "tail -f #{shared_path}/log/#{stage}.log"
end


before "deploy", "deploy:web:disable"
before "deploy", "backup"
after "deploy", "deploy:cleanup"
  
namespace :deploy do
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
    
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
  namespace :web do
      desc <<-DESC
        Present a maintenance page to visitors. Disables your application's web \
        interface by writing a "maintenance.html" file to each web server. The \
        servers must be configured to detect the presence of this file, and if \
        it is present, always display it instead of performing the request.

        By default, the maintenance page will just say the site is down for \
        "maintenance", and will be back "shortly", but you can customize the \
        page by specifying the REASON and UNTIL environment variables:

          $ cap deploy:web:disable \\
                REASON="a hardware upgrade" \\
                UNTIL="12pm Central Time"

        Further customization will require that you write your own task.
      DESC
      task :disable, :roles => :web do
        require 'erb'
        on_rollback { run "rm #{shared_path}/system/maintenance.html" }

        reason = ENV['REASON']
        deadline = ENV['UNTIL']      
        template = File.read('app/views/pages/maintenance.html.erb')
        page = ERB.new(template).result(binding)

        put page, "#{shared_path}/system/maintenance.html", :mode => 0644
      end
    end
end

task :backup, :roles => :db, :only => { :primary => true } do
  filename = "#{backup_dir}/#{application}.dump.#{Time.now.to_f}.sql.bz2"
  text = capture "cat #{deploy_to}/current/config/database.yml"
  yaml = YAML::load(text)

  on_rollback { run "rm #{filename}" }
  run "mysqldump -u #{yaml[rails_env]['username']} -p #{yaml[rails_env]['database']} | bzip2 -c > #{filename}" do |ch, stream, out|
    ch.send_data "#{yaml[rails_env]['password']}\n" if out =~ /^Enter password:/
  end
end
