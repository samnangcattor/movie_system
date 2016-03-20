class AddDriveLinkToLink < ActiveRecord::Migration
  def change
    add_column :links, :drive_url, :text
  end
end
