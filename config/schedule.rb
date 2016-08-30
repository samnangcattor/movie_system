every :hour do
  rake "app:download_torrent"
end

every 30.minutes do
  rake "app:check_torrent"
end
