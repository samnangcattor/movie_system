class AddMovieTitleToLink < ActiveRecord::Migration
  def change
    add_column :links, :title_movie, :string
  end
end
