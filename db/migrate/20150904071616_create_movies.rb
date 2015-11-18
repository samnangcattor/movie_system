class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title, default: "Default Movie"
      t.string :description
      t.string :link_movie
      t.string :link_cover
      t.references :year, index: true

      t.timestamps null: false
    end
  end
end
