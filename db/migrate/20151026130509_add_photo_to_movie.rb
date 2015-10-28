class AddPhotoToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :photo, :string
  end
end
