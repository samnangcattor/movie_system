FactoryGirl.define do
  factory :image do
    is_main Settings.images.status.is_main
    photo "default_movie_1.png"
  end
end
