class AddSlugToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :slug, :string, unique: true
  end
end
