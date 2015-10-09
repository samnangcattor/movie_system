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

    puts "Create 100 images"
    Movie.all.each do |movie|
      FactoryGirl.create :image, movie: movie
    end

    puts "Create 5 categoreis"
    5.times {FactoryGirl.create :category}

    puts "Create database is sucessfull"
  end
end
