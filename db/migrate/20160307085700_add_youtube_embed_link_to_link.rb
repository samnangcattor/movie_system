class AddYoutubeEmbedLinkToLink < ActiveRecord::Migration
  def change
    add_column :links, :youtube_embed_link, :text
  end
end
