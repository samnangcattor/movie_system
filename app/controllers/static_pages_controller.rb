class StaticPagesController < ApplicationController
  def home
    @movies = Movie.all.order(created_at: :DESC).limit(Settings.movie.slide)
  end
end
