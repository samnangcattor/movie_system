class AddSlugToIndex < ActiveRecord::Migration
  def change
    add_index :movies, :slug
  end
end
