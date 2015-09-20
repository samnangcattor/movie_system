class MoviesController < ApplicationController
  def index
    @movies = Movie.all.order(created_at: :ASC).page params[:page]
  end

  def show
    @movie = Movie.find params[:id]
    render layout: "movie"
  end
end
