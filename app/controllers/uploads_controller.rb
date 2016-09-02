class UploadsController < ApplicationController
  OOB_URI = "http://localhost:3000/oauth2callback"
  APPLICATION_NAME = "Movidhdkh"
  CLIENT_SECRETS_PATH = "lib/google_drive/client_secret.json"
  CREDENTIALS_PATH = File.join "lib/google_drive/", ".credentials", "moviehdkh-com.yaml"
  SCOPE = "https://www.googleapis.com/auth/drive"

  def index
    file = params[:file]
    service = Google::Apis::DriveV2::DriveService.new
    service.client_options.application_name = APPLICATION_NAME
    service.authorization = authorize
  end

  def update
    client_id = Google::Auth::ClientId.from_file CLIENT_SECRETS_PATH
    token_store = Google::Auth::Stores::FileTokenStore.new file: CREDENTIALS_PATH
    authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
    user_id = "default"
    credentials = authorizer.get_credentials user_id
    code = params[:code]
    credentials = authorizer.get_and_store_credentials_from_code user_id: user_id, code: code, base_url: OOB_URI
    redirect_to uploads_path
  end

  private
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

  def upload_to_drive service, movie_file, folder_id
    file = {
      parents: [{id: folder_id}],
      title: movie_file.name
    }
    service.insert_file file, upload_source: movie_file.file_path, content_type: movie_file.mime_type
  end
end
