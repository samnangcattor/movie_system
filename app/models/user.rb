class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  enum role: [:admin]

  has_many :movie_histories
  has_many :reviews
  has_many :comments
  has_many :likes
  has_many :requests
end
