class Comment < ActiveRecord::Base
  belongs_to :review
  belongs_to :user

  validates :comment, presence: true, lenght: {maximum: Settings.comment.comment.maximum}
end
