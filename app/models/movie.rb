class Movie < ActiveRecord::Base
  paginates_per Settings.page.per_page_movie

  after_save :load_into_soulmate
  after_create :create_link
  before_destroy :remove_from_soulmate

  is_impressionable

  belongs_to :year

  enum quality: [:hd, :sd]

  has_many :movie_categories
  has_many :categories, through: :movie_categories
  has_one :link

  validates :title, presence: true
  validates :description, presence: true
  validates :link_movie, presence: true

  delegate :number, to: :year, prefix: true, allow_nil: true

  scope :by_most_review, ->{Impression.group :impressionable_id}
  scope :by_suggestion, ->{where(suggestion: true).order(updated_at: :DESC)}
  scope :by_slide, ->{where(slide: true).order(updated_at: :DESC).limit(10)}

  def get_impression
    Impression.where impressionable_id: id
  end

  def get_quality
    if quality == Settings.movie.hd
      Settings.images.stream.hd
    elsif quality == Settings.movie.sd
      Settings.images.stream.sd
    end
  end

  private
  def create_link
    Link.create movie_id: id, link_title: title, url: link_movie
  end
end
