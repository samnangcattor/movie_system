class CreateTitles < ActiveRecord::Migration
  def change
    create_table :titles do |t|
      t.string :title
      t.integer :imdb
      t.text :photo
      t.text :torrent
      t.integer :release
      t.references :year, index: true

      t.timestamps null: false
    end
  end
end
