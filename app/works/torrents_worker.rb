class TorrentsWorker
  @queue = :torrents

  def self.perform torrent_movie
    movie = ActionController::Parameters.new title: torrent_movie["title"],
      photo: torrent_movie["photo"], year: torrent_movie["year"], torrent: torrent_movie["torrent"]
    Supervise.single_dowload movie
  end
end
