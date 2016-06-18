class MoviesController < ApplicationController
  before_action :search_movie

  OOB_URI = "http://moviehdkh.com/oauth2callback"
  APPLICATION_NAME = "Movidhdkh"
  CLIENT_SECRETS_PATH = "lib/google_drive/client_secret.json"
  CREDENTIALS_PATH = File.join "lib/google_drive/", ".credentials", "moviehdkh.yaml"
  SCOPE = "https://www.googleapis.com/auth/drive"

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
    render layout: "application"
  end

  def update
    client_id = Google::Auth::ClientId.from_file CLIENT_SECRETS_PATH
    token_store = Google::Auth::Stores::FileTokenStore.new file: CREDENTIALS_PATH
    authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
    user_id = "default"
    credentials = authorizer.get_credentials user_id
    code = params[:code]
    credentials = authorizer.get_and_store_credentials_from_code user_id: user_id, code: code, base_url: OOB_URI
    redirect_to movies_path
  end

 def show
    @movie = Movie.find params[:id]
    @movie_categories = @movie.categories
    @movie_suggestions = Movie.by_suggestion.page(params[:page_3]).per 10
    @progress_status = nil
    filter_quality = params[:filter_quality]
    if @movie.link.robot?
      # begin
      #   uri = URI @movie.link.url_default
      #   response = Net::HTTP.get_response uri
      #   code = response.code.to_s
      # rescue
      #   code = "404"
      # end
      # if code == "302"
      #   @link_default = @movie.link.url_default
      #   @link_hd = @movie.link.url_hd
      # else
      #  @progress_status = get_progress_status_id @movie.id, @movie.link if @movie.link.robot?
      # end
      url = "https://drive.google.com/file/d/" + @movie.link.file_id + "/view"
      link_video = @movie.collect_movie_from_url url
      if link_video.size == 2
        @link_default = link_video[1]
        @link_hd = link_video[0]
      else
        @link_default = link_video[0]
      end
    else
      movie_link = @movie.link
      @link_default = movie_link.url_default
      @link_hd = movie_link.url_hd
      @link_super_hd = movie_link.ulr_super_hd
    end

    case filter_quality.to_i
    when Settings.qualities.medium then
      @link_movie = @link_medium
    when Settings.qualities.hight then
      @link_movie = @link_hd
    else
      @link_movie = @link_default
    end
    if filter_quality.present?
      respond_to :js
    end
  end

  def new_article_banner
  end

  private
  def search_movie
    @categories = Category.all.order name: :ASC
    @years = Year.all.order number: :ASC
    @q = Movie.ransack params[:q]
  end

  def get_progress_status_id movie_id, movie_link
    progress_status = nil
    title = nil
    if ProgressStatus.all.map(&:progress_name).include? movie_id
      progress_status = ProgressStatus.find_by progress_name: movie_id
      if progress_status.status_progress == Settings.status_progress.finished
        title = google_login movie_link
        ProgressStatus.update progress_status.id, status_progress: Settings.status_progress.start, start_time: Time.now
        Resque.enqueue MovieWorker, movie_id, progress_status.id, title
      end
    else
      title = google_login movie_link
      progress_status = ProgressStatus.create progress_name: movie_id, status_progress: Settings.status_progress.start, start_time: Time.now
      Resque.enqueue MovieWorker, movie_id, progress_status.id, title
    end
    progress_status
  end

  def google_login movie_link
    service = Google::Apis::DriveV2::DriveService.new
    service.client_options.application_name = APPLICATION_NAME
    service.authorization = authorize
    file = service.get_file movie_link.file_id
    old_folder_id = file.parents[0].id
    new_folder_id = if old_folder_id == "0B7KgDDTcGh7lT0lQMXpfNGp0dVk"
      "0B7KgDDTcGh7leDQwcHVUZ2VLQUU"
    else
      "0B7KgDDTcGh7lT0lQMXpfNGp0dVk"
    end
    title_new = "#{file.original_filename}-#{file.id}-#{new_folder_id}"
    metadata = {title: title_new}
    options = {add_parents: new_folder_id, remove_parents: old_folder_id}
    service.patch_file file.id, metadata, options
    Link.update movie_link.id, folder: new_folder_id
    file.original_filename + "-" + file.id
  end

  def authorize
    FileUtils.mkdir_p File.dirname(CREDENTIALS_PATH)

    client_id = Google::Auth::ClientId.from_file CLIENT_SECRETS_PATH
    token_store = Google::Auth::Stores::FileTokenStore.new file: CREDENTIALS_PATH
    authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
    user_id = "default"
    credentials = authorizer.get_credentials user_id
    if credentials.nil?
      url = authorizer.get_authorization_url base_url: OOB_URI
      redirect_to url
    end
    credentials
  end
end
