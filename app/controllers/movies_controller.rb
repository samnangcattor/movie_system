class MoviesController < ApplicationController
  before_action :search_movie

  OOB_URI = "http://www.moviehdkh.com/oauth2callback"
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
    @service = nil
    if @movie.link.robot?
      url = "https://drive.google.com/file/d/" + @movie.link.file_id + "/view"
      link_videos = @movie.collect_movie_from_url url
      begin
        @link_default = link_videos[0]
        if link_videos.size == 2
          @link_hd = link_videos[1]
          @link_default = link_videos[0]
        end
      rescue
        @link_default = ""
        @link_hd = ""
      end
    else
      @link_default = @movie.link.url_default
      @link_hd = @movie.link.url_hd
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

  def get_progress_status_id movie_id, movie_link
    progress_status = nil
    title = nil
    if ProgressStatus.all.map(&:progress_name).include? movie_id
      progress_status = ProgressStatus.find_by progress_name: movie_id
      if progress_status.status_progress == Settings.status_progress.finished
        title = google_login movie_link
        ProgressStatus.update progress_status.id, status_progress: Settings.status_progress.start, start_time: Time.now
        MovieWorker.perform_async movie_id, progress_status.id, title
      end
    else
      title = google_login movie_link
      progress_status = ProgressStatus.create progress_name: movie_id, status_progress: Settings.status_progress.start, start_time: Time.now
      MovieWorker.perform_async movie_id, progress_status.id, title
    end
    progress_status
  end

  def google_login movie_link
    service = Google::Apis::DriveV2::DriveService.new
    service.client_options.application_name = APPLICATION_NAME
    service.authorization = authorize
    file = service.get_file movie_link.file_id
    title_new = file.title.delete(".#{file.file_extension}") +"_.#{file.file_extension}"
    file.title = title_new
    service.update_file file.id, file
    parent_folder_id = (file.parents)[0].id
    new_parent_folder_id = if parent_folder_id == "0B7KgDDTcGh7lT0lQMXpfNGp0dVk"
      "0B7KgDDTcGh7leDQwcHVUZ2VLQUU"
    else
      "0B7KgDDTcGh7lT0lQMXpfNGp0dVk"
    end
    file = service.get_file file.id

    service.insert_child new_parent_folder_id, file
    service.delete_parent file.id, (file.parents)[0].id
    Link.update movie_link.id, folder: new_parent_folder_id
    title_new
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
