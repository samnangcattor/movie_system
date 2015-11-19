FactoryGirl.define do
  factory :movie do
    title Faker::Name.title
    description Faker::Lorem.paragraph
    link_movie "https://d6e49ee7cc2b3dba6382c892d84a5563a34cd81e.googledrive.com/host/0B7kOlRv8XBC3cHhpVHhQd3g0RjA/A%20Knight's%20Tale%20(2001)/A%20Knight's%20Tale.720p.BrRip.x264.YIFY.mkv"
    link_cover "http://7-themes.com/data_images/out/50/6942657-avengers-movie-hd-wallpapers.jpg"
    photo "https://upload.wikimedia.org/wikipedia/vi/5/5d/Spy2015_TeaserPoster.jpg"
    suggestion true
  end
end
