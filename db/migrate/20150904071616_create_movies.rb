class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title, default: "Default Movie"
      t.text :description
      t.text :link_movie
      t.text :link_cover
      t.references :year, index: true

      t.timestamps null: false
    end
  end
end
