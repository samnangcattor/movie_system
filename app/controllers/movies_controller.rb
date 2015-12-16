class MoviesController < ApplicationController
  caches_page [:index, :show]

  before_action :search_movie

  impressionist actions: [:show]

  def index
    if params[:search].present?
      @movie_searchs = @q.result(distinct: true).order(created_at: :DESC).page params[:page]
      render layout: "category"
    else
      @movies = Movie.all.order(created_at: :DESC).page params[:page_1]
      @slideshows = Movie.by_slide
    end
  end

  def show
    @movie = Movie.find params[:id]
    @movies = Movie.all.order(created_at: :DESC).limit 10
    @movie_categories = @movie.categories
    @impressions = @movie.get_impression
    @movie.impressionist_count filter: :all
    @movie_suggestions = Movie.by_suggestion.page(params[:page_3]).per 10
    respond_to do |format|
      format.html {render layout: "movie"}
      format.js
    end
  end

  private
  def search_movie
    @categories = Rails.cache.fetch("categories") do
      Category.all.order name: :ASC
    end
    @years = Rails.cache.fetch("years") do
      Year.all.order number: :ASC
    end
    q = Hash.new
    q[:title_cont] = params[:search]
    @q = Movie.ransack q
  end
end
