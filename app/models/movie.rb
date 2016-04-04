class Movie < ActiveRecord::Base
  EMAIL = "damsamnang@gmail.com"
  PASSWORD = "MV@pherom11@KH"

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
    begin
      uri = URI url
      reponse= Net::HTTP.get_response uri
      reponse["location"].to_s
    rescue
     "unknow"
    end
  end

  def get_quality
    if quality == Settings.movie.hd
      Settings.images.stream.hd
    elsif quality == Settings.movie.sd
      Settings.images.stream.sd
    end
  end

  def get_pool_video url
    uri = URI url
    body = get_login_google uri
    data = body.split '"fmt_stream_map","'
    data2 = data[1].split "]"
    data3 = data2[0].split '"'
    data4 = data3[0].split ","
    data4
  end

  def get_quality_video url
    scope_video = url.split "|"
    [scope_video[0], scope_video[1]]
  end

  def get_link_movie url
    url_convert = url.gsub "\\u003d", "="
    url_result = URI.unescape url_convert
    last_result = url_result.gsub "\\u0026", "&"
    last_result.to_s
  end

  def collect_movie_from_url url
    link_result = []
    pool_videos = get_pool_video url
    pool_videos.each do |pool_video|
      pvideo = get_quality_video pool_video
      link = get_link_redirect_google get_link_movie(pvideo[1])
      if pvideo[0] == "18"
        link_result << link
      elsif pvideo[0] == "22"
        link_result << link
      end
    end
    link_result
  end

  private
  def create_link
    Link.create movie_id: id, link_title: title, url_default: link_movie
  end

  def get_login_google url
    agent = Mechanize.new
    page_email = agent.get url
    form_email = page_email.forms[0]
    form_email.field_with(name: "Email").value = EMAIL
    page_password = agent.submit form_email
    form_password = page_password.forms[0]
    form_password.field_with(name: "Passwd").value = PASSWORD
    page_view = agent.submit form_password
    page_view.body
  end

  def get_link_redirect_google url
    result = url.split "docs.google.com"
    new_url = "https://redirector.googlevideo.com" + result[1]
    new_url
  end
end
