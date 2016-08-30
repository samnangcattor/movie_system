class Supervise
  class << self
    def import_movies
      movie_titles = Movie.all.map &:title
      movies_in_extra = Rss.movies_from_extra
      movies_in_extra.each do |movie|
        unless movie_titles.include? movie[:title]
          description = movie[:title] + "movie hd kh link full"
          year = Year.find_by number: movie[:year]
          Movie.transaction do
            Movie.create title: movie[:title], description: description,
              link_movie: "null", year_id: year.id, photo: movie[:photo]
          end
        end
      end
    end

    def file_mime_type file
      mime_type = if file.name.include?(".mkv") || file.name.include?(".MKV")
        "video/x-matroska"
      elsif file.name.include?(".mp4") || file.name.include?(".MP4")
        "video/mp4"
      elsif  file.name.include?(".avi") || file.name.include?(".AVI")
        "video/x-msvideo"
      end
      mime_type
    end
  end
end
