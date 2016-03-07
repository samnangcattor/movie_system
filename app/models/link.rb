class Link < ActiveRecord::Base
  enum embed_link: [:sky_drive, :google_plus, :youtube]

  belongs_to :movie

  mount_uploader :subtitle, SubtitleUploader
end
