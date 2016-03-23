class AddDriveLinkToLink < ActiveRecord::Migration
  def change
    add_column :links, :redirect, :boolean
  end
end
