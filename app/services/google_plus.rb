class GooglePlus
  include Capybara::DSL

  SECRET_PATH = Rails.root.join('lib', 'google_drive/g_plus_secret.json')

  class << self
    def upload file_name, progress_status_id
      Headless.new(display: 100, reuse: true, destroy_at_exit: true).start
      @instance ||= new
      @instance.upload(file_name, progress_status_id)
    end
  end

  def initialize
    @secret = JSON.parse(File.read(SECRET_PATH))
    page.current_window.maximize
    page.driver.browser.allow_url('*')
  end

  def upload file_name, progress_status_id
    login_to_google_account
    switch_to_google_plus
    upload_from_google_drive(file_name)
  ensure
    ProgressStatus.update progress_status_id, status_progress: Settings.status_progress.finished,
      end_time: Time.now, remaining_time: Settings.remaining_time.fnished
    page.driver.browser.clear_cookies
    page.driver.browser.reset!
  end

  private

  def login_to_google_account
    visit '/ServiceLogin'
    with_retry(3) { fill_in 'Email', with: @secret['email'] }
    click_on 'next'
    with_retry(3) { fill_in 'Passwd', with: @secret['password'] }
    click_on 'signIn'
  end

  def switch_to_google_plus
    with_retry(3) { find('a.gb_b.gb_Rb').click }
    find('ul.gb_ja.gb_ca li#ogbkddg\:9').click
  end

  def upload_from_google_drive(file_name)
    with_retry(10) { all('div.dv')[1].click }
    with_retry(10) { find('div.HY.fya').click }
    with_retry(10) { all('div.d-xc')[2].click }
    with_retry(10) { find('input.a-pb-N-z.b-hb').set(file_name) }
    with_retry(10) { all('div.d-k-l.b-c.b-c-U')[0].click }
    with_retry(10) { all('td.a-Hb-e-kb-xd.a-Hb-e-xd').last.click }

    all('td.a-Hb-e-kb-xd.a-Hb-e-xd').last.click
    all('td.a-Hb-e-kb-xd.a-Hb-e-xd').last.click

    with_retry(10) { find('div.d-k-l.b-c.b-c-U.a-Qb-e-D6').click }
    with_retry(10) { find('div.d-k-l.b-c.b-c-U.a-Qb-e-D6').click }
    with_retry(10) { find('div.d-k-l.b-c.b-c-Ba.qy.jt').click }
    post_url = with_retry(10) { all('a.d-s.ob.Ks').first[:href] }
    get_videos(post_url)
  end

  def get_videos(post_url)
    format = /photos\/(\d+)\/albums\/(\d+)\/(\d+)/i
    user_id, album_id, photo_id = post_url.match(format).captures
    segment = "#{user_id}/albumid/#{album_id}/photoid/#{photo_id}"
    picasa_url = "https://picasaweb.google.com/data/feed/api/user/#{segment}"
    agent = Movie.authenthicate_mechanize
    page = agent.get picasa_url
    Nokogiri::XML(page.body).xpath("//media:content[@type='video/mpeg4']").map{|video| OpenStruct.new(video.to_h)}
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

  private_class_method :new
end
