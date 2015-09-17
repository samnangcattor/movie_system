namespace :db do
  desc "Remaking data"
  task remake_data: :environment do
    Rake::Task["db:migrate:reset"].invoke

    puts "Create admin user"
    FactoryGirl.create :admin

    puts "Create normal user"
    20.times {FactoryGirl.create :user}

    puts "Create 100 movies"
    100.times {FactoryGirl.create :movie}
  end
end
