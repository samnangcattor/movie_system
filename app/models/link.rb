class Link < ActiveRecord::Base
  enum embed_link: [:google_plus, :drive, :sky_drive, :youtube, :amazon]

  belongs_to :movie

  mount_uploader :subtitle, SubtitleUploader

  REDIRECT_URL = "https://redirector.googlevideo.com/videoplayback?"

  class << self
    def list_links_api file_id
      result = []
      service = GoogleDrive.get_service
      file = service.get_file file_id
      url = "http://api.getlinkdrive.com/getlink?url=https://drive.google.com/file/d/"+ file_id +"/view"
      GoogleDrive.permission_to_public service, file_id
      result_from_api = get_result_from_api url
      result << list_url_api(result_from_api)
      GoogleDrive.permission_to_private service, file_id
      result
    rescue
      GoogleDrive.permission_to_private service, file_id
      []
    end

    def list_links file_id
      result = []
      url = Settings.video_info + file_id
      body = page_body url, file_id
      if body.present?
        list_splits = split_url body
        list_splits.each do |split|
          result << link_video(split)
        end
      end
      result.compact
    end

    private
    def get_result_from_api url
      # uri = URI url
      # response = Net::HTTP.get uri
      res = RestClient.get(url)
      JSON.parse res.body
    end

    def list_url_api links
      result = []
      links.each do |link|
        ui = link["src"].gsub "api.getlinkdrive.com", "moviehdkh.com"
        result << { file: ui, type: 'mp4', label: link['label'] }
      end
      result
    end


    def convert_result_from_api url
      httpc = HTTPClient.new
      resp = httpc.get url
      location = resp.header['Location'][0]
      # location.gsub "api.getlinkdrive.com", "moviehdkh.com"
    end



    def page_body url, file_id
      service = GoogleDrive.get_service
      page = ""
      file = service.get_file file_id, fields: "owners"
      if file.owners[0].display_name.include?("Dam Samnul") || file.owners[0].display_name.include?("damsamnang")
        access_token = service.authorization.access_token
        url = "https://drive.google.com/a/moviehdkh.com/get_video_info?docid=" +
          file_id + "&access_token=" + access_token
        GoogleDrive.permission_to_public service, file_id
        page = Nokogiri::HTML open(url)
        GoogleDrive.permission_to_private service, file_id
      else
        page = Nokogiri::HTML open(url)
      end
      page.search "body"
    end

    def split_url body
      decode_body = URI.decode(URI.decode(body.to_s))
      remove_fmt_stream = decode_body.split("fmt_stream_map=")[1]
      remove_fmt_stream.split "|"
    end

    def link_video link
      result = if link.include? "itag=37"
        link = get_link_redirect_google link
        {file: link, type: "mp4", label: "1080"}
      elsif link.include? "itag=22"
        link = get_link_redirect_google link
        {file: link, type: "mp4", label: "720"}
      elsif link.include? "itag=59"
        link = get_link_redirect_google link
        {file: link, type: "mp4", label: "480"}
      elsif link.include? "itag=18"
        link = get_link_redirect_google link
        {file: link, type: "mp4", label: "360", "default": true}
      end
      result
    end

    def get_link_redirect_google url
      url = "https://redirector.googlevideo.com/videoplayback?" + url.split("com/videoplayback?")[1]
      url = url.sub /ipbits=\d+/, "ipbits=0"
      url = url.sub /pl=\w+,\d+/, "pl=21"
      # url = url.sub /&safm=\d+,\d+/, ""
      url
    end
  end
end
