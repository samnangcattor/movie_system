class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :movie, index: true
      t.references :user, index: true
      t.string :review
      t.integer :rate

      t.timestamps null: false
    end
  end
end
