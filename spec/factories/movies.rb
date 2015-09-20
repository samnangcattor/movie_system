FactoryGirl.define do
  factory :movie do
    title Faker::Name.title
    description Faker::Lorem.paragraph
    link_trailer Faker::Internet.url
    publish_date 2015
  end
end
