class Video < ActiveRecord::Base
  belongs_to :title
  VIDEO_STATUS = Settings.status.map &:first

  enum status: VIDEO_STATUS
end
