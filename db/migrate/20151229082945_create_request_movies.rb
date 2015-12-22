class CreateRequestMovies < ActiveRecord::Migration
  def change
    create_table :request_movies do |t|
      t.text :photo
      t.text :link
      t.string :title

      t.timestamps null: false
    end
  end
end
