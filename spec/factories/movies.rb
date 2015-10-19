FactoryGirl.define do
  factory :movie do
    title Faker::Name.title
    description Faker::Lorem.paragraph
    link_trailer Faker::Internet.url
    publish_date 2015
    link_cover "https://farm9.staticflickr.com/8672/15697849757_507ba9d04e_b.jpg"
  end
end
