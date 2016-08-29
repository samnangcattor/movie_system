class Rss
  class << self
    def movies_from_extra
      result = []
      rss = open Settings.rss_feeds.extratorrent
      feeds = RSS::Parser.parse rss
      feeds.items.each{|feed| result << feed_detail(feed)}
      result
    end

    def feed_detail feed
      description = feed.description
      description_html  = Nokogiri::HTML description
      imdb_link = nil
      description_html.search("//a[@href]").map(&:attributes).each do |item|
        imdb_link = item["href"].value if item["href"].value.include? "imdb.com/title"
      end
      imdb_id = imdb_link.split("imdb.com/title/tt")[1].delete "/"
      imdb = Imdb::Movie.new imdb_id
      enclosure = feed.enclosure
      torrent = enclosure.url
      title =  imdb.title + " (" + imdb.year.to_s + ")"
      {title: title, photo: imdb.poster,
        year: imdb.year, torrent: torrent}
    end
  end
end
