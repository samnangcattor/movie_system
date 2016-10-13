class Robot
  EMAIL = "damsamnang@moviehdkh.com"
  PASSWORD = "D@msamnang1989"
  REDIRECT_URL = "https://redirector.googlevideo.com/videoplayback?"

  class << self
    def link_from_drive file_id
      video_arr = []
      Headless.new(display: 100, reuse: true, destroy_at_exit: true).start
      driver = Selenium::WebDriver.for :firefox
      url = "https://docs.google.com/file/d/"+ file_id +"/view"
      driver.navigate.to url
      email = driver.find_element :xpath, "//input[@id = 'Email']"
      email.send_keys EMAIL
      email.send_keys :enter
      password = driver.find_element :xpath, "//input[@id = 'Passwd']"
      password.send_keys PASSWORD
      password.send_keys :enter
      sleep 5
      source = driver.page_source
      page = Nokogiri::HTML source
      driver.quit
      list_links = split_url page
      links = video_links list_links
      links.each do |link|
        link_video = quality_video link
        video_arr << link_video if link_video.present?
      end
      video_arr
    end

    def split_url page
      body = page.search("body").to_s
      data_temp_1 = body.split 'url_encoded_fmt_stream_map","'
      data_temp_2 = data_temp_1[1].split '"]'
      data_temp_3 = data_temp_2[0].split "\\u0026"
    end


    def video_links list_links
      result = []
      list_links.each do |url|
        if url.include? "videoplayback"
          link = url.split("url\\u003d")[1]
          link = URI.unescape link
          link = link.split("videoplayback?")[1]
          link = REDIRECT_URL + link
          result << link
        end
      end
      result
    end

    def quality_video link
      result = if link.include? "itag=37"
        {"file": link, "type": "mp4", "label": "1080"}
      elsif link.include? "itag=22"
        {"file": link, "type": "mp4", "label": "720"}
      elsif link.include? "itag=59"
        {"file": link, "type": "mp4", "label": "480"}
      elsif link.include? "itag=18"
        {"file": link, "type": "mp4", "label": "360"}
      end
      result
    end
  end
end
