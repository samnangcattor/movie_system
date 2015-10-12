class MoviesController < ApplicationController
  def index
    @movies = Movie.all.order(created_at: :DESC).page params[:page]
  end

  def show
    @movie = Movie.find params[:id]
    @movies = Movie.all.order(created_at: :DESC).limit(10)
    render layout: "movie"
  end
end
