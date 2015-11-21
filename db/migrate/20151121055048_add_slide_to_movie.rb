class AddSlideToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :slide, :boolean, default: false
  end
end
