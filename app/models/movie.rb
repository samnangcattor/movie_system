class Movie < ActiveRecord::Base
  paginates_per Settings.page.per_page_movie

  after_create :create_link

  belongs_to :year

  enum quality: [:hd, :sd]

  has_many :movie_categories
  has_many :categories, through: :movie_categories
  has_one :link

  validates :title, presence: true
  validates :description, presence: true
  validates :link_movie, presence: true

  delegate :number, to: :year, prefix: true, allow_nil: true

  scope :by_suggestion, ->{where(suggestion: true).order(updated_at: :DESC)}
  scope :by_slide, ->{where(slide: true).order(updated_at: :DESC).limit(10)}
  scope :by_no_cinema, ->{where(cinema: false).order(updated_at: :DESC)}

  def get_link_video url
    c = Curl::Easy.new url do |curl|
      curl.follow_location = true
      curl.head = true
    end
    c.perform
    c.last_effective_url.to_s
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
    Link.create movie_id: id, link_title: title, url_default: link_movie
  end
end
