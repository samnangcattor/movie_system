class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
      t.integer :status
      t.references :movie, index: true

      t.timestamps null: false
    end
  end
end
