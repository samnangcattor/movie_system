class MoviesController < ApplicationController
  def index
    @movies = Movie.all.order(created_at: :ASC).page params[:page]
  end
end
