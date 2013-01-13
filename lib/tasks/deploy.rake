require 'rake'

task :deploy => "deploy:staging"

namespace :deploy do
  desc "Deploy to Heroku staging"
  task :staging, [:local_branch] do |t, args|
    args.with_defaults(:local_branch => "develop")
    Deployer.new("staging", args[:local_branch]).deploy
  end

  desc "Deploy to Heroku production"
  task :production, [:local_branch] do |t, args|
    args.with_defaults(:local_branch => "master")
    Deployer.new("production", args[:local_branch]).deploy
  end
end

class Deployer
  attr_reader :branch
  
  def initialize(environment, local_branch)
    @environment = environment
    @local_branch = local_branch
    @branch      = `git symbolic-ref HEAD 2> /dev/null`.gsub("refs/heads/", "").strip
    @commit      = `git rev-parse HEAD`.strip
  end

  def deploy
    ensure_clean_git
    push_heroku
    migrate
    #hoptoad_deploy
  end

  private
  def git_dirty?
    `[[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]]`
    dirty = $?.success?
  end

  def ensure_clean_git
    if git_dirty?
      raise "Can't deploy without a clean git status."
    end
  end

  def push_heroku
    run "git push #{@environment} -f #{@local_branch}:master"
  end

  def migrate
    heroku "run rake db:migrate --remote #{@environment} --app bookdrive-#{@environment}"
  end

  def hoptoad_deploy
    run "bundle exec rake airbrake:deploy TO=#{@environment} REVISION=#{@commit} REPO=git@github.com:bookdrive/bookdrive.git"
  end

  def run(command)
    puts "  #{command}"
    %x{#{command}}
  end
  
  def heroku(command)
    system("GEM_HOME='' BUNDLE_GEMFILE='' GEM_PATH='' RUBYOPT='' /usr/local/heroku/bin/heroku #{command}")
  end
end
