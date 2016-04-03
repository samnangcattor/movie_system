class MoviesController < ApplicationController
  before_action :search_movie

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
    @movie = Movie.find params[:id]
    @movie_categories = @movie.categories
    @movie_suggestions = Movie.by_suggestion.page(params[:page_3]).per 10
    if @movie.link.google_plus?
        @link_default = @movie.get_link_video @movie.link.url_default
        @link_hd = @movie.get_link_video @movie.link.url_hd if @movie.link.url_hd.present?
        if @movie.link.redirect_url?
          @link_default = @movie.link.url_default
          @link_hd = @movie.link.url_hd
        end
    elsif @movie.link.drive?
      link_videos = @movie.collect_movie_from_url @movie.link.drive_url
      @link_default = link_videos[0]
      if link_videos == 2
        @link_hd = link_videos[0]
        @link_default = link_videos[1]
      end
    end
    render layout: "movie"
  end

  def new_article_banner
    render layout: false
  end

  private
  def search_movie
    @categories = Category.all.order name: :ASC
    @years = Year.all.order number: :ASC
    @q = Movie.ransack params[:q]
  end
end
