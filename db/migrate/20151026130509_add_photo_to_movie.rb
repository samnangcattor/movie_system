class AddPhotoToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :photo, :text
  end
end
