class GoogleDrive
  class << self
    OOB_URI = "https://moviehdkh/oauth2callback"
    APPLICATION_NAME = "Movidhdkh"
    CLIENT_SECRETS_PATH = "lib/google_drive/client_secret.json"
    CREDENTIALS_PATH = File.join "lib/google_drive/", ".credentials", "moviehdkh.yaml"
    SCOPE = "https://www.googleapis.com/auth/drive"

    def get_service
      service = Google::Apis::DriveV2::DriveService.new.tap do |client|
        client.request_options.timeout_sec = 10800
        client.request_options.open_timeout_sec = 10800
        client.request_options.retries = 5
      end
      service.client_options.application_name = APPLICATION_NAME
      service.authorization = authorize
      service
    end

    def upload_to_drive service, movie_file, folder_id
      file = {
        parents: [{id: folder_id}],
        title: movie_file[:title]
      }
      service.insert_file file, upload_source: movie_file[:file_path], content_type: movie_file[:mime_type]
    end

    private
    def authorize
      FileUtils.mkdir_p File.dirname(CREDENTIALS_PATH)

      client_id = Google::Auth::ClientId.from_file CLIENT_SECRETS_PATH
      token_store = Google::Auth::Stores::FileTokenStore.new file: CREDENTIALS_PATH
      authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
      user_id = "default"
      credentials = authorizer.get_credentials user_id
      credentials
    end
  end
end
