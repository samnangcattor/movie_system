class AddStatusLinkToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :status_link, :boolean, default: false
  end
end
