class CreateComingSoonMovies < ActiveRecord::Migration
  def change
    create_table :coming_soon_movies do |t|
      t.text :photo
      t.text :link
      t.string :title

      t.timestamps null: false
    end
  end
end
