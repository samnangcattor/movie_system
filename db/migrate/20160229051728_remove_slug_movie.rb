class RemoveSlugMovie < ActiveRecord::Migration
  def change
    remove_column :movies, :slug
  end
end
