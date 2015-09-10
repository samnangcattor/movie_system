class Category < ActiveRecord::Base
  include RailsAdmin::Address

  has_many :movie_categories

  validates :name, presence: true, uniqueness: true, length: {maximum: Settings.category.name.maximum}
end
