class Movie < ActiveRecord::Base
  has_many :movie_categories
  has_many :likes
  has_many :movie_histories
  has_many :reviews
  has_many :images

  validates :title, presence: true, length: {maximum: Settings.movie.title.maximum}
  validates :description, presence: true, length:  {maximum: Settings.movie.description.maximum}
  validates :publish_dated, presence: true
  validates :link_trailer, presence: true
end
