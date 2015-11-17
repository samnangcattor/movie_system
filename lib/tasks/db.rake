namespace :db do
  desc "Remaking data"
  task remake_data: :environment do
    Rake::Task["db:migrate:reset"].invoke

    puts "Create admin user"
    FactoryGirl.create :admin_user

    puts "Create normal user"
    20.times {FactoryGirl.create :user}

    puts "Create year"
    FactoryGirl.create :year

    puts "Create 100 movies"
      30.times {FactoryGirl.create :movie, year: Year.first}

    puts "Create 100 images"
    Movie.all.each do |movie|
      FactoryGirl.create :image, movie: movie
    end

    puts "Create 10 categoreis"
    10.times {FactoryGirl.create :category}

    puts "Create movie have contain category"
    Movie.all.each do |movie|
      Category.all.each do |category|
        FactoryGirl.create :movie_category, movie: movie, category: category
      end
    end

    puts "Create database is sucessfull"
  end
end
