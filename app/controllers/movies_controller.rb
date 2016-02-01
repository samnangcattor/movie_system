class MoviesController < ApplicationController
  caches_page [:index, :show]

  before_action :search_movie

  impressionist actions: [:show]

  def index
    @coming_soon_movies = ComingSoonMovie.all
    @po_pular_movies = PoPularMovie.all
    @request_movies = RequestMovie.all
    if @q.conditions.present?
      @movie_searchs = @q.result(distinct: true).order(created_at: :DESC).page params[:page]
      render layout: "category"
    else
      @movies = Movie.by_no_cinema.page params[:page_1]
      @slideshows = Movie.by_slide
    end
  end

  def show
    @movie = Movie.friendly.find params[:id]
    @movies = Movie.all.order(created_at: :DESC).limit 10
    @movie_categories = @movie.categories
    @impressions = @movie.get_impression
    impressionist @movie
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
