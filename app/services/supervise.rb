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
  end
end
