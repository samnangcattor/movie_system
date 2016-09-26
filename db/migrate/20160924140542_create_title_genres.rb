class CreateTitleGenres < ActiveRecord::Migration
  def change
    create_table :title_genres do |t|
      t.references :title, index: true
      t.references :genre, index: true

      t.timestamps null: false
    end
  end
end
