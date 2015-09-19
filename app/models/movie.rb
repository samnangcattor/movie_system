class Movie < ActiveRecord::Base
  paginates_per Settings.page.per_page_movie

  has_many :movie_categories
  has_many :likes, dependent: :destroy
  has_many :movie_histories, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :images, dependent: :destroy

  validates :title, presence: true, length: {maximum: Settings.movie.title.maximum}
  validates :description, presence: true, length:  {maximum: Settings.movie.description.maximum}
  validates :publish_date, presence: true
  validates :link_trailer, presence: true
end
