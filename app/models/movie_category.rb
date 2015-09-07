class MovieCategory < ActiveRecord::Base
  belongs_to :category
  belongs_to :movie
end
