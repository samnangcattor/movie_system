class RemoveStatusLinkFromLink < ActiveRecord::Migration
  def change
    remove_column :links, :status_link
  end
end
