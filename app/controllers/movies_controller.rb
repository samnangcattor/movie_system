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
    @link_video = []
    @link_default = ""
    @link_medium = ""
    @link_hd = ""
    if @movie.link.robot? && @movie.link.file_id != "null"
      redis = Redis.new
      file_id = @movie.link.file_id
      link_video_json = redis.get "link_video-#{file_id}"
      if link_video_json.present?
        @link_video = JSON.parse link_video_json
        if @link_video.count == 1
          @link_default = JSON.parse(@link_video[0])["file"]
        elsif @link_video.count == 2
          @link_medium = JSON.parse(@link_video[0])["file"]
          @link_default = JSON.parse(@link_video[1])["file"]
        elsif @link_video.count == 3
          @link_hd = JSON.parse(@link_video[0])["file"]
          @link_medium = JSON.parse(@link_video[1])["file"]
          @link_default = JSON.parse(@link_video[2])["file"]
        end
      else
        @link_video = Movie.list_links file_id
        redis.set "link_video-#{file_id}", @link_video
        redis.expire "link_video-#{file_id}", 9000
        if @link_video.count == 1
          @link_default = @link_video[0]["file"]
        elsif @link_video.count == 2
          @link_medium = @link_video[0]["file"]
          @link_default = @link_video[1]["file"]
        elsif @link_video.count == 3
          @link_hd = @link_video[0]["file"]
          @link_medium = @link_video[1]["file"]
          @link_default = @link_video[2]["file"]
        end
      end
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
