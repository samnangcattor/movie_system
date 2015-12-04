class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.references :movie, index: true
      t.string :link_title
      t.text :url

      t.timestamps null: false
    end
  end
end
