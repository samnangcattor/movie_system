class AddUrlSuperHdToLinks < ActiveRecord::Migration
  def change
    add_column :links, :url_super_hd, :text
  end
end
