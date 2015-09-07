class Request < ActiveRecord::Base
  belongs_to :user

  validates :name, presence: true, lenght: {maximum: Settings.request.name.maximum}
  validates :description, presence: true, lenght: {maximum: Settings.request.description.maximum}
end
