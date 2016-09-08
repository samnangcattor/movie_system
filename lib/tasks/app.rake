namespace :app do
  task download_torrent: :environment do
    Supervise.import_movies
  end

  task check_torrent: :environment do
    Supervise.check_torrent_status
  end

  task check_file_google_drive: :environment do
    Supervise.check_file_ready?
  end
end
