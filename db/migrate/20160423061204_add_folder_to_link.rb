class AddFolderToLink < ActiveRecord::Migration
  def change
    add_column :links, :folder, :string
  end
end
