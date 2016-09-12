class LinksWorker
  @queue = :links

  def self.perform movie_id
    movie = Movie.find movie_id
    file_id = movie.link.file_id
    service = GoogleDrive.get_service
    new_file = service.copy_file file_id
    movie = movie.link.update file_back_up: new_file.id
  end
end
