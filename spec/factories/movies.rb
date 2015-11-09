FactoryGirl.define do
  factory :movie do
    title Faker::Name.title
    description Faker::Lorem.paragraph
    link_trailer Faker::Internet.url
    link_cover "http://7-themes.com/data_images/out/50/6942657-avengers-movie-hd-wallpapers.jpg"
    photo "https://upload.wikimedia.org/wikipedia/vi/5/5d/Spy2015_TeaserPoster.jpg"
  end
end
