class Supervise
  class << self
    def import_movies
      movies_in_extra = Rss.movies_from_extra
      downloads = Download.all
      movies_in_extra.each do |movie|
        if check_movie? downloads, movie
          download = Torrent.add movie[:torrent]
          generate_movies movie
          last_movie = Movie.last
          Download.create status: 0, movie: last_movie, torrent: download[:id]
        end
      end
    end

    def check_movie? downloads, movies_extra
      downloads.each do |download|
        return false if download.movie.title.include? movies_extra[:title]
      end
      true
    end

    def check_torrent_status
      downloads = Download.all
      downloads.each do |download|
        if download.status == 0
          torrent_status = Torrent.get download.torrent
          if torrent_status[0].present?
            if torrent_status[0][:percentDone].to_i == 1
              movie = download.movie
              service = GoogleDrive.get_service
              movie_file = prepare_file_upload movie.title, download.torrent
              file_uploaded = GoogleDrive.upload_to_drive service, movie_file, "0B7KgDDTcGh7lUGl5Vk40WE5FYVk"
              download.update status: 1, file_progress: 1
              movie.link.update file_id: file_uploaded.id
              Torrent.remove download.torrent
            end
          end
        end
      end
    end

    def prepare_file_upload title, download_id
      movie_path = file_from_directory download_id
      mime_type = file_mime_type movie_path
      {"title": title, "file_path": movie_path, "mime_type": mime_type}
    end

    def file_mime_type movie_path
      mime_type = if movie_path.include?(".mkv") || movie_path.include?(".MKV")
        "video/x-matroska"
      elsif movie_path.include?(".mp4") || movie_path.include?(".MP4")
        "video/mp4"
      elsif movie_path.include?(".avi") || movie_path.include?(".AVI")
        "video/x-msvideo"
      end
      mime_type
    end

    def generate_movies movie
      description = movie[:title] + "movie hd kh link full"
      year = Year.find_by number: movie[:year]
      Movie.transaction do
        Movie.create title: movie[:title], description: description,
          link_movie: "null", year_id: year.id, photo: movie[:photo], cinema: 1
      end
    end

    def file_from_directory download_id
      file_torrent = Torrent.get download_id
      path = file_torrent[0][:downloadDir] + "/" + file_torrent[0][:name]
      list_path_files = []
      if File.directory? path
        list_files =  Dir.entries path
        list_files.each{|file| list_path_files << (path + "/" + file)}
      else
        list_path_files << path
      end
      file_movie_paths = []
      video_types = [".AVI", ".avi", ".mp4", ".MP4", ".mkv", ".MKV"]
      list_path_files.each do |file_path|
        video_types.each do |type|
          if file_path.include? type
            file_movie_paths << file_path
            next
          end
        end
      end
      movie_file_path = nil
      max_size = 0
      file_movie_paths.each do |file_path|
        file_size = File.size file_path
        if File.size(file_path) >= max_size
          max_size = file_size
          movie_file_path = file_path
        end
      end
      movie_file_path
    end

    def single_dowload movie
      download = Torrent.add movie[:torrent]
      generate_movies movie
      last_movie = Movie.last
      Download.create status: 0, movie: last_movie, torrent: download[:id]
    end

    def check_file_ready?
      service = GoogleDrive.get_service
      downloads = Download.all
      downloads.each do |download|
        if download.file_progress == 1
          movie = download.movie
          file = service.get_file movie.link.file_id
          if file.thumbnail_link.present?
            movie.update cinema: false
            download.update file_progress: 0
          end
        end
      end
    end
  end
end
