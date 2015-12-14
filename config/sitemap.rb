SitemapGenerator::Sitemap.default_host = "http://www.moviehdkh.com"
SitemapGenerator::Sitemap.adapter = SitemapGenerator::WaveAdapter.new
SitemapGenerator::Sitemap.public_path = "tmp/"
SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/"

SitemapGenerator::Sitemap.create do
  Category.find_each do |category|
    add category_path(category), lastmod: category.updated_at
  end
end

SitemapGenerator::Sitemap.ping_search_engines
