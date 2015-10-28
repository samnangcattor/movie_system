class MoviesController < ApplicationController
  def index
    @movies = Movie.all.order(created_at: :DESC).page params[:page]
    @categories = Category.all.order name: :ASC
  end

  def show
    @categories = Category.all.order name: :ASC
    @movie = Movie.find params[:id]
    @movies = Movie.all.order(created_at: :DESC).limit(10)
    render layout: "movie"
  end
end
