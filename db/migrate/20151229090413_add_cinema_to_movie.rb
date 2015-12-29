class AddCinemaToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :cinema, :boolean, default: false
  end
end
