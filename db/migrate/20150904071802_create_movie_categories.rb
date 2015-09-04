class CreateMovieCategories < ActiveRecord::Migration
  def change
    create_table :movie_categories do |t|
      t.references :movie, index: true
      t.references :category, index: true

      t.timestamps null: false
    end
  end
end
