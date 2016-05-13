class GoogleDrive
  class << self
    SECRET_FILE_PATH = "lib/google_drive/client_secret.json"
    CREDENTIALS_PATH = "lib/google_drive/.credentials/moviehdkh.yaml"

    def credentials
      authorize do |authorizer, drive|
        authorizer.get_credentials(Settings.google_drive.user_id)
      end
    end

    def authorization_url
      authorize do |authorizer, drive|
        authorizer.get_authorization_url(base_url: Settings.google_drive.base_url)
      end
    end

    def save_credentials(options = {})
      options.merge!({
        user_id: Settings.google_drive.user_id,
        base_url: Settings.google_drive.base_url
      })
      authorize do |authorizer, drive|
        authorizer.get_and_store_credentials_from_code(options)
      end
    end

    def get_file(file_id, options = {})
      authorize { |authorizer, drive| drive.get_file(file_id, options) }
    end

    def patch_file(file_id, file_obj = nil, options = {})
      authorize { |authorizer, drive| drive.patch_file(file_id, file_obj, options) }
    end

    private

    def authorize
      scope = Google::Apis::DriveV2::AUTH_DRIVE
      token_store = Google::Auth::Stores::FileTokenStore.new file: SECRET_FILE_PATH
      client_id = Google::Auth::ClientId.from_file SECRET_FILE_PATH
      authorizer = Google::Auth::UserAuthorizer.new(client_id, scope, token_store)

      drive = Google::Apis::DriveV2::DriveService.new
      drive.authorization = authorizer.get_credentials("default")

      yield authorizer, drive
    end
  end
end
