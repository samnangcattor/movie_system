class Link < ActiveRecord::Base
  belongs_to :movie

  mount_uploader :subtitle, SubtitleUploader
end
