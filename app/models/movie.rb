class Movie < ActiveRecord::Base
  paginates_per Settings.page.per_page_movie

  after_save :load_into_soulmate
  before_destroy :remove_from_soulmate

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

  scope :search_title, ->query{where "title LIKE ?", query}

  private
  def load_into_soulmate
    loader = Soulmate::Loader.new("movies")
    loader.add("term" => title, "id" => self.id, "data" => {
      "link" => Rails.application.routes.url_helpers.movie_path(self)
    })
  end

  def remove_from_soulmate
    loader = Soulmate::Loader.new("movies")
      loader.remove("id" => self.id)
  end
end
