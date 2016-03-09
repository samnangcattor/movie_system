class Link < ActiveRecord::Base
  enum embed_link: [:google_plus, :sky_drive, :youtube, :amazon]

  belongs_to :movie

  mount_uploader :subtitle, SubtitleUploader
end
