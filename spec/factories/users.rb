FactoryGirl.define do
  factory :admin, class: User do
    email "admin@gmail.com"
    password "12345678"
    password_confirmation "12345678"
    role Settings.roles.admin
  end

  factory :user do
    sequence(:name) {|n| "user-#{n}"}
    sequence(:email) {|n| "user-#{n}@example.com"}
    password "12345678"
    password_confirmation "12345678"
    role Settings.roles.normal
  end
end
