class Category < ActiveRecord::Base
  has_many :movie_categories

  validates :name, presence: true, uniqueness: true, length: {maximum: Settings.category.name.maximum}
end
