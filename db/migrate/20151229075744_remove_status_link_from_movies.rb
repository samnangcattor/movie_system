class RemoveStatusLinkFromMovies < ActiveRecord::Migration
  def change
    remove_column :movies, :status_link
  end
end
