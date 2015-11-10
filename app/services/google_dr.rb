require "google/api_client"
require "google/api_client/client_secrets"
require "google/api_client/auth/installed_app"
require "google/api_client/auth/storage"
require "google/api_client/auth/storages/file_store"
require "fileutils"

class GoogleDr
  attr_accessor :client, :drive_api

  APPLICATION_NAME = "moviehdkh"
  CLIENT_SECRETS_PATH = Rails.root.join("tmp", "google_api_credentials.json")
  SCOPE = "https://www.googleapis.com/auth/drive.metadata.readonly"
  CREDENTIALS_PATH = Rails.root.join("tmp", ".credentials",
                             "drive-movie-system.json")

  def initialize
    @client = Google::APIClient.new application_name: APPLICATION_NAME
    @client.authorization = authorize
    @drive_api = @client.discovered_api "drive", "v2"
  end

  def authorize
    FileUtils.mkdir_p(File.dirname CREDENTIALS_PATH)

    file_store = Google::APIClient::FileStore.new CREDENTIALS_PATH
    storage = Google::APIClient::Storage.new file_store
    auth = storage.authorize
    if auth.nil? || (auth.expired? && auth.refresh_token.nil?)
      app_info = Google::APIClient::ClientSecrets.load CLIENT_SECRETS_PATH
      flow = Google::APIClient::InstalledAppFlow.new({
        client_id: app_info.client_id,
        client_secret: app_info.client_secret,
        scope: SCOPE})
      auth = flow.authorize storage
    end
    auth
  end

  def list_item
    results = @client.execute!(
      :api_method => @drive_api.files.list,
      :parameters => {:maxResults => 10})
    puts "Files:"
    puts "No files found" if results.data.items.empty?
    results.data.items.each do |file|
      puts "#{file.title} (#{file.id})"
    end
  end
end
