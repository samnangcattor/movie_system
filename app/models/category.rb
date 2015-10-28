class Category < ActiveRecord::Base
  has_many :movie_categories
  has_many :movies, through: :movie_categories

  validates :name, presence: true, uniqueness: true
end
