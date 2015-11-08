# config valid only for current version of Capistrano
lock "3.4.0"

set :application, "movie_system"
set :repo_url, "git@github.com:samnangcattor/movie_system.git"
set :assets_roles, [:app]
set :deploy_ref, ENV["DEPLOY_REF"]
set :bundle_binstubs, ->{shared_path.join("bin")}

if fetch(:deploy_ref)
  set :branch, fetch(:deploy_ref)
else
  raise "Please set $DEPLOY_REF"
end

set :deploy_to, "/usr/local/rails_apps/#{fetch :application}"
set :pid_file, "#{shared_path}/tmp/pids/unicorn.pid"
set :unicorn_rack_env, ENV["RAILS_ENV"] || "production"
set :unicorn_config_path, "#{current_path}/config/unicorn.rb"

set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

set :default_env, {
  rails_env: ENV["RAILS_ENV"],
  deploy_ref: ENV["DEPLOY_REF"],
  deploy_ref_type: ENV["DEPLOY_REF_TYPE"],
  database_name: ENV["DATABASE_NAME"],
  database_hostname: ENV["DATABASE_HOSTNAME"],
  database_username: ENV["DATABASE_USERNAME"],
  database_password: ENV["DATABASE_PASSWORD"],
  devise_secret_key: ENV["DEVISE_SECRET_KEY"],
}

namespace :deploy do
  desc "create database"
  task :create_database do
    on roles(:db) do |host|
      within "#{release_path}" do
        with rails_env: ENV["RAILS_ENV"] do
          execute :rake, "db:create"
        end
      end
    end
  end
  before :migrate, :create_database

  desc "seed database"
  task :seed do
    on roles(:db) do |host|
      within "#{release_path}" do
        with rails_env: ENV["RAILS_ENV"] do
          execute :rake, "db:seed"
        end
      end
    end
  end
  after :migrate, :seed

  desc "link dotenv"
  task :link_dotenv do
    on roles(:app) do
      execute "ln -s /home/deploy/.env #{release_path}/.env"
    end
  end
  before :restart, :link_dotenv

  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke "unicorn:restart"
    end
  end
  after :publishing, :restart

  desc "update ec2 tags"
  task :update_ec2_tags do
    on roles(:app) do
      within "#{release_path}" do
        execute :rake, "tag:update_ec2_tags" if fetch(:stage) == :production
      end
    end
  end
  after :restart, :update_ec2_tags
end
