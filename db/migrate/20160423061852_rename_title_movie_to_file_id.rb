class RenameTitleMovieToFileId < ActiveRecord::Migration
  def change
    rename_column :links, :title_movie, :file_id
  end
end
