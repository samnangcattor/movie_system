class Rss
  class << self
    def movies_from_extra
      result = []
      rss = open "http://etproxy.top/rss.xml?type=hot&cat=XVID+DIVX"
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
      if imdb_link.present?
        imdb_id = imdb_link.split("imdb.com/title/tt")[1].delete "/"
        imdb = Imdb::Movie.new imdb_id
        torrent = maget_link feed.link
        title =  imdb.title + " (" + imdb.year.to_s + ")"
        year = imdb.year
        poster = imdb.poster
      else
        torrent = maget_link feed.link
        title = feed.link.split("http://extratorrent.cc/torrent/")[1]
        year = "2000"
        poster = "https://moviehdkh.com/assets/logo-a89ac077ebeb6e980852ad282214a68f0cf5966f43a863588b2bdad9749bc7c4.png"
      end
        {title: title, photo: poster,
          year: year, torrent: torrent}
    end

    def maget_link url
      url = url.split("http://extratorrent.cc/")[1]
      url = "http://etproxy.top/" + url
      agent = Mechanize.new
      page = agent.get url
      magnet = page.search "//a[@title='Magnet link']"
      magnet[0].attributes["href"].value
    end
  end
end
