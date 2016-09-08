every :hour do
  rake "app:download_torrent"
end

every 30.minutes do
  rake "app:check_torrent"
end

every 40.minutes do
  rake "app:check_file_google_drive"
end
