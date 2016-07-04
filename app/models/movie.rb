class Movie < ActiveRecord::Base
  EMAIL = "damsamnang@gmail.com"
  PASSWORD = "DamS@mnang1989#"

  paginates_per Settings.page.per_page_movie

  after_create :create_link

  belongs_to :year

  enum quality: [:hd, :sd]

  has_many :movie_categories
  has_many :categories, through: :movie_categories
  has_one :link, dependent: :destroy

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
    rescue
      ""
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
        elsif pvideo[0]== "59"
          link_result << link
        elsif pvideo[0] == "22"
          link_result << link
        end
      end
      link_result
    rescue
      ""
    end

  class << self
    FAMILY_URL = "https://plus.google.com/u/0/stream/circles/p5f7a55328b99dd81?gmbpt=true&fd=1&pli=1"
    DRIVE_URL = "https://drive.google.com/drive/my-drive"
    COMMUNITY = "https://plus.google.com/u/0/communities/106443094303154072116"

    def get_link_from_google_plus title, progress_status_id
      Headless.new(display: 100, reuse: true, destroy_at_exit: true).start
      driver = Selenium::WebDriver.for :firefox
      agent = authenthicate_mechanize
      begin
        driver.navigate.to FAMILY_URL
        driver.manage.window.maximize
        action_log_in_google_plus driver
        action_choose_google_drive driver
        action_search_google_drive driver, title
        action_click_share_video driver
        feed_url = action_get_link_feed driver
        link_videos = action_get_link_video_from_feed agent, feed_url[0]
        driver.quit
        link_videos
      rescue
        ProgressStatus.update progress_status_id, status_progress: Settings.status_progress.finished,
          end_time: Time.now, remaining_time: Settings.remaining_time.fnished
        driver.quit
      end
    end

    def action_log_in_google_plus driver
      wait = Selenium::WebDriver::Wait.new(:timeout => 10)
      wait.until{driver.find_element(:id, "Email").send_keys EMAIL}
      wait.until{driver.find_element(:id, "next").click}
      wait.until{driver.find_element(:id, "Passwd").send_keys PASSWORD}
      wait.until{driver.find_element(:id, "signIn").click}
    end

    def action_choose_google_drive driver
      wait = Selenium::WebDriver::Wait.new(timeout: 10)
      sleep 5
      driver.find_elements(:xpath, "//div[@class = 'dv']")[1].click
      wait.until{driver.find_element(:xpath, "//div[@class = 'HY fya']")}
      driver.find_element(:xpath, "//div[@class = 'HY fya']").click
      wait.until{driver.find_elements(:xpath, "//div[@class = 'd-xc']")[1]}
      driver.find_elements(:xpath, "//div[@class = 'd-xc']")[1].click
    end

    def action_search_google_drive driver, title
      wait = Selenium::WebDriver::Wait.new(timeout: 10)
      wait.until{driver.find_element(:xpath, "//input[@class = 'a-pb-N-z b-hb']")}
      driver.find_element(:xpath, "//input[@class = 'a-pb-N-z b-hb']").send_keys title
      wait.until{driver.find_element(:xpath, "//div[@class = 'd-k-l b-c b-c-U']")}
      driver.find_element(:xpath, "//div[@class = 'd-k-l b-c b-c-U']").click
      sleep 5
      driver.find_elements(:xpath, "//td[@class = 'a-Hb-e-kb-xd a-Hb-e-xd']").last.click
      driver.find_elements(:xpath, "//td[@class = 'a-Hb-e-kb-xd a-Hb-e-xd']").last.click
      driver.find_elements(:xpath, "//td[@class = 'a-Hb-e-kb-xd a-Hb-e-xd']").last.click
      sleep 7
      driver.find_element(:xpath, "//div[@id = 'picker:ap:4']").click
      sleep 7
      driver.find_element(:xpath, "//div[@id = 'picker:ap:6']").click
    end

    def action_click_share_video driver
      wait = Selenium::WebDriver::Wait.new(timeout: 10)
      wait.until{driver.find_element(:xpath, "//html").send_keys [:control, '-']}
      wait.until{driver.find_element(:xpath, "//html").send_keys [:control, '-']}
      wait.until{driver.find_element(:xpath, "//html").send_keys [:control, '-']}
      wait.until{driver.find_element(:xpath, "//div[@class = 'd-k-l b-c b-c-Ba qy jt']")}
      driver.find_element(:xpath, "//div[@class = 'd-k-l b-c b-c-Ba qy jt']").click
    end

    def action_get_link_feed driver
      wait = Selenium::WebDriver::Wait.new(timeout: 10)
      sleep 3
      link_post = driver.find_elements(:xpath, "//a[@class= 'd-s ob Ks']").first.attribute("href")
      array_id = link_post.split "/"
      feed_url = "https://picasaweb.google.com/data/feed/api/user/" +
        array_id[6] + "/albumid/" + array_id[8] + "/photoid/" + array_id[9] + "?prettyprint=true"
      [feed_url, link_post]
    end

    def authenthicate_mechanize
      agent = Mechanize.new
      page_email = agent.get DRIVE_URL
      form_email = page_email.forms[0]
      form_email.field_with(name: "Email").value = EMAIL
      page_password = agent.submit form_email
      form_password = page_password.forms[0]
      form_password.field_with(name: "Passwd").value = PASSWORD
      page_view = agent.submit form_password
      agent
    end

    def action_get_link_video_from_feed agent, feed_url
      link_videos = []
      feed_page = agent.get feed_url
      body = feed_page.body
      xml_doc = Nokogiri::XML body
      datas = xml_doc.to_s.split "<media:content"
      datas.each{|data| link_videos << data.split("\"")[1] if data.include? "mpeg4"}
      link_videos
    end

    def action_close_browser driver
      wait = Selenium::WebDriver::Wait.new(timeout: 10)
      wait.until{driver.find_element(:xpath, "//div[@class= 'ys']")}
      driver.find_element(:xpath, "//div[@class= 'ys']").click
      wait.until{driver.find_element(:xpath, "//span[@class= 'd-s xw if']")}
      driver.find_element(:xpath, "//span[@class= 'd-s xw if']").click
      wait.until{driver.find_elements(:class, "d-A-B")[5]}
      driver.find_elements(:class, "d-A-B")[5].click
      wait.until{driver.find_element(:xpath, "//button[@name= 'yes']")}
      driver.find_element(:xpath, "//button[@name= 'yes']").click
      driver.quit
    end
  end

  private
  def create_link
    Link.create movie_id: id, link_title: title, file_id: link_movie, robot: true, redirect_url: true
  end

  def get_login_google url
    agent = Mechanize.new
    page_email = agent.get "https://accounts.google.com/"
    form_email = page_email.forms[0]
    form_email.field_with(name: "Email").value = EMAIL
    page_password = agent.submit form_email
    form_password = page_password.forms[0]
    form_password.field_with(name: "Passwd").value = PASSWORD
    agent.submit form_password
    page_view = agent.get url
    page_view.body
  end

  def get_link_redirect_google url
    result = url.split "docs.google.com/videoplayback?"
    # arr_params = result[1].split "&"
    # new_url = "https://redirector.googlevideo.com/videoplayback?" + arr_params[3] +
    #   "&" + arr_params[7] + "&" + arr_params[1] + "&" + arr_params[10] + "&" +
    #   arr_params[11] + "&" + arr_params[8] + "&" + arr_params[9] + "&" +
    #   arr_params[2] + "&" + arr_params[13] + "&" + arr_params[6] + "&" +
    #   arr_params[0] + "&" + arr_params[16] + "&" + arr_params[12] + "&" +
    #   arr_params[15] + "&" + arr_params[17] + "&" + arr_params[4] + "&" +
    #   arr_params[5] + "&" + "filename=video.mp4"
    result[1].gsub! "texmex", "explorer"
    result[1].gsub! "mv=m", "mv=u"
    new_url = "https://redirector.googlevideo.com/videoplayback?" + result[1]
    movie_url =
    new_url
  end

  def with_retry(tries)
    yield
  rescue
    tries -= 1
    if tries > 1
      sleep(1)
      retry
    else
      raise $!
    end
  end
end
