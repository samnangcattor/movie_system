namespace :db do
  desc "Remaking data"
  task remake_data: :environment do
    Rake::Task["db:migrate:reset"].invoke

    puts "Create admin user"
    FactoryGirl.create :admin

    puts "Create normal user"
    20.times {FactoryGirl.create :user}

    puts "Create 100 movies"
    30.times {FactoryGirl.create :movie}

    puts "Create 100 images"
    Movie.all.each do |movie|
      FactoryGirl.create :image, movie: movie
    end

    puts "Create 5 categoreis"
    3.times {FactoryGirl.create :category}

    puts "Create movie with category"
    Movie.all.each do |movie|
      Category.all.each do |category|
        FactoryGirl.create :movie_category, movie: movie, category: category
      end
    end

    puts "Create database is sucessfull"
  end
end
