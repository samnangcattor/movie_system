class AddAmazonUrlToLink < ActiveRecord::Migration
  def change
    add_column :links, :amazon_url, :text
  end
end
