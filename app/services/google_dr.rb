class GoogleDr
  attr_accessor :client, :drive_api

  APPLICATION_NAME = "moviehdkh"
  CLIENT_SECRETS_PATH = Rails.root.join("tmp", "google_api_credentials.json")
  SCOPE = "https://www.googleapis.com/auth/drive"
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

  def print_file file_id
    result = @client.execute(
      :api_method => @drive_api.files.get,
      :parameters => {"fileId" => file_id })
    if result.status == 200
      file = result.data
      puts "Title: #{file.title}"
      puts "Description: #{file.description}"
      puts "MIME type: #{file.mime_type}"
    else
      puts "An error occurred: #{result.data['error']['message']}"
    end
     result.data
  end

  def download_file file
    if file.download_url
      result = @client.execute(uri: file.download_url)
      if result.status == 200
        return result.body
      else
        puts "An error occurred: #{result.data['error']['message']}"
        return nil
      end
    else
      # The file doesn't have any content stored on Drive.
      return nil
    end
    result
  end

  def list_files_in_application_data_folder
    result = Array.new
    page_token = nil
    begin
      parameters = {}
      if page_token.to_s != ""
        parameters["pageToken"] = page_token
      else
        parameters["q"] = "'appfolder' in parents"
      end
      api_result = @client.execute(
        :api_method => @drive_api.files.list,
        :parameters => parameters)
      if api_result.status == 200
        files = api_result.data
        result.concat(files.items)
        page_token = files.next_page_token
      else
        puts "An error occurred: #{result.data['error']['message']}"
        page_token = nil
      end
    end while page_token.to_s != ""
    result
  end

  def create_public_folder folder_name
    file = @drive_api.files.insert.request_schema.new({
      "title" => folder_name,
      "mimeType" => "application/vnd.google-apps.folder"
    })

    result = @client.execute(
        :api_method => @drive_api.files.insert,
        :body_object => file)

    permission = @drive_api.permissions.insert.request_schema.new({
      "value" => "",
      "type" => "anyone",
      "role" => "reader"
    })

    file_id = result.data["id"]

    result = @client.execute(
      :api_method => @drive_api.permissions.insert,
      :body_object => permission,
      :parameters => {"fileId" => file_id})

    result.data
  end
end
