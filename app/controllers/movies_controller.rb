class MoviesController < ApplicationController
  caches_page [:index, :show]

  before_action :search_movie

  impressionist actions: [:show]

  def index
    @coming_soon_movies = Rails.cache.fetch("coming_soon_movies") do
      ComingSoonMovie.all
    end
    @po_pular_movies = Rails.cache.fetch("po_pular_movies") do
      PoPularMovie.all
    end
    @request_movies = Rails.cache.fetch("request_movies") do
      RequestMovie.all
    end
    if @q.conditions.present?
      @movie_searchs = @q.result(distinct: true).order(created_at: :DESC).page params[:page]
      render layout: "category"
    else
      @movies = Movie.by_no_cinema.page params[:page_1]
      @slideshows = Movie.by_slide
    end
  end

  def show
    @movie = Rails.cache.fetch("movie_#{params[:id]}") do
      Movie.find params[:id]
    end
    @movie_categories = Rails.cache.fetch("movie_categories") do
      @movie.categories
    end
    @impressions = @movie.get_impression
    @movie.impressionist_count filter: :all
    @movie_suggestions = Movie.by_suggestion.page(params[:page_3]).per 10
    render layout: "movie"
  end

  private
  def search_movie
    @categories = Rails.cache.fetch("categories") do
      Category.all.order name: :ASC
    end
    @years = Rails.cache.fetch("years") do
      Year.all.order number: :ASC
    end
    @q = Movie.ransack params[:q]
  end
end
