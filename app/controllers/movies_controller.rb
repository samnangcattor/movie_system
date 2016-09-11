class MoviesController < ApplicationController
  before_action :search_movie

  OOB_URI = "http://moviehdkh.com/oauth2callback"
  APPLICATION_NAME = "Movidhdkh"
  CLIENT_SECRETS_PATH = "lib/google_drive/client_secret.json"
  CREDENTIALS_PATH = File.join "lib/google_drive/", ".credentials", "moviehdkh.yaml"
  SCOPE = "https://www.googleapis.com/auth/drive"

  def index
    @movies = Movie.by_no_cinema.page params[:page]
    @slideshows = Movie.by_slide
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
    if @movie.link.robot?
      url = "https://docs.google.com/get_video_info?authuser=&docid=" + @movie.link.file_id
      @link_video = @movie.collect_movie_from_url url
    end
    if @link_video.count == 1
      @link_default = @link_video[0].link
    elsif @link_video.count == 2
      @link_medium = @link_video[0].link
      @link_default = @link_video[1].link
    elsif @link_video.count == 3
      @link_hd = @link_video[0].link
      @link_medium = @link_video[1].link
      @link_default = @link_video[2].link
    end
  end

  def new_article_banner
  end

  private
  def search_movie
    @categories = Category.all.order name: :ASC
    @years = Year.all.order number: :ASC
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
