class MoviesController < ApplicationController
  before_action :search_movie

  def index
    @categories = Category.all.order name: :ASC
    if params[:search].present?
      @movie_searchs = @q.result(distinct: true).order(created_at: :DESC).page params[:page]
      render layout: "category"
    else
      @movies = Movie.all.order(created_at: :DESC).page params[:page]
    end
  end

  def show
    @categories = Category.all.order name: :ASC
    @movie = Movie.find params[:id]
    @movies = Movie.all.order(created_at: :DESC).limit(10)
    @movie_categories = @movie.categories
    render layout: "movie"
  end

  private
  def search_movie
    q = Hash.new
    q[:title_cont] = params[:search]
    @q = Movie.ransack q
  end
end
