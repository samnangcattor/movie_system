class ChangeUrlToUrlDefaultInLinks < ActiveRecord::Migration
  def change
    rename_column :links, :url, :url_default
    add_column :links, :url_hd, :text
  end
end
