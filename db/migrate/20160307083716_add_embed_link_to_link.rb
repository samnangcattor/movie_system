class AddEmbedLinkToLink < ActiveRecord::Migration
  def change
    add_column :links, :embed_link, :integer, default: 0
  end
end
