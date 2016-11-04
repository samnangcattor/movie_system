class Link < ActiveRecord::Base
  enum embed_link: [:google_plus, :drive, :sky_drive, :youtube, :amazon]

  belongs_to :movie

  mount_uploader :subtitle, SubtitleUploader

  REDIRECT_URL = "https://redirector.googlevideo.com/videoplayback?"

  class << self
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
    def page_body url, file_id
      service = GoogleDrive.get_service
      page = ""
      file = service.get_file file_id
      if file.owners[0].display_name.include? "Dam Samnul"
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
        {file: link, type: "mp4", label: "1080"}.to_json
      elsif link.include? "itag=22"
        link = get_link_redirect_google link
        {file: link, type: "mp4", label: "720"}.to_json
      elsif link.include? "itag=59"
        link = get_link_redirect_google link
        {file: link, type: "mp4", label: "480"}.to_json
      elsif link.include? "itag=18"
        link = get_link_redirect_google link
        {file: link, type: "mp4", label: "360", "default": true}.to_json
      end
      result
    end

    def get_link_redirect_google url
      url = "https://redirector.googlevideo.com/videoplayback?" + url.split("com/videoplayback?")[1]
      url = url.sub /ipbits=\d+/, "ipbits=8"
      url = url.sub /pl=\w+,\d+/, "pl=18"
      url
    end
  end
end
