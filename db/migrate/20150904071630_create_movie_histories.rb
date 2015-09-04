class CreateMovieHistories < ActiveRecord::Migration
  def change
    create_table :movie_histories do |t|
      t.references :movie, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
  end
end
