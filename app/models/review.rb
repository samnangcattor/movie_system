class Review < ActiveRecord::Base
  belongs_to :movie
  belongs_to :user
  has_many :comments

  validates :review, presence: true, length: {maximum: Settings.review.review.maximum}
  validates :rate, presence: true
end
