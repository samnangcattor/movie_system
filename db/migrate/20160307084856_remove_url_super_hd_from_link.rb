class RemoveUrlSuperHdFromLink < ActiveRecord::Migration
  def change
    remove_column :links, :url_super_hd
  end
end
