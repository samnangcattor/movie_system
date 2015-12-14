class AddStatusLinkToLink < ActiveRecord::Migration
  def change
    add_column :links, :status_link, :boolean, default: false
  end
end
