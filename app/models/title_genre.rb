class TitleGenre < ActiveRecord::Base
  belongs_to :title
  belongs_to :genre
end
