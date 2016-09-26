class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :file
      t.integer :status, default: 0
      t.references :title, index: true

      t.timestamps null: false
    end
  end
end
