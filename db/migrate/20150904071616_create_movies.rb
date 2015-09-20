class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title, default: "Default Movie"
      t.string :description
      t.string :link_trailer
      t.integer :publish_date

      t.timestamps null: false
    end
  end
end
