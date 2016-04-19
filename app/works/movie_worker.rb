class MovieWorker
  @queue = :movie

  def self.perform movie_id
    movie = Movie.find movie_id
    link_videos = movie.collect_movie_from_url movie.link.drive_url
    link_default = link_videos[0]
    if link_videos.size == 2
      link_hd = link_videos[0]
      link_default = link_videos[1]
    end
    Link.update movie.id, url_default: link_default, url_hd: link_hd,
      embed_link: 0, redirect_url: true
  end
end
