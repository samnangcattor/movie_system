class Movie < ActiveRecord::Base
  paginates_per Settings.page.per_page_movie

  belongs_to :year

  has_many :movie_categories
  has_many :likes, dependent: :destroy
  has_many :movie_histories, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :categories, through: :movie_categories

  validates :title, presence: true, length: {maximum: Settings.movie.title.maximum}
  validates :description, presence: true, length:  {maximum: Settings.movie.description.maximum}
  validates :link_trailer, presence: true

  delegate :number, to: :year, prefix: true, allow_nil: true
end
