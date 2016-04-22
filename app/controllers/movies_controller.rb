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
    @progress_status = nil
    if @movie.link.drive?
      Resque.enqueue MovieWorker, @movie.id, @progress_status.id
    else
      uri = URI @movie.link.url_default
      response = Net::HTTP.get_response uri
      if response.code == "302"
        @link_default = @movie.link.url_default
        @link_hd = @movie.link.url_hd
      else
        @progress_status = get_progress_status_id @movie.id
        Resque.enqueue MovieWorker, @movie.id, @progress_status.id
      end
    end
    render layout: "movie"
  end

  def new_article_banner
  end

  private
  def search_movie
    @categories = Category.all.order name: :ASC
    @years = Year.all.order number: :ASC
    @q = Movie.ransack params[:q]
  end

  def get_progress_status_id movie_id
    progress_status = nil
    if ProgressStatus.all.map(&:progress_name).include? movie_id
      progress_status = ProgressStatus.find_by progress_name: movie_id
      if progress_status.status_progress == Settings.status_progress.finished
        ProgressStatus.update progress_status.id, status_progress: Settings.status_progress.start, start_time: Time.now
      end
    else
      progress_status = ProgressStatus.create progress_name: movie_id, status_progress: Settings.status_progress.start, start_time: Time.now
    end
    progress_status
  end
end
