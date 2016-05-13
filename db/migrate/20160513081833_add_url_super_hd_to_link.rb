class AddUrlSuperHdToLink < ActiveRecord::Migration
  def change
    add_column :links, :ulr_super_hd, :text
  end
end
