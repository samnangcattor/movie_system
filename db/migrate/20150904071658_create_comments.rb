class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :review, index: true
      t.references :user, index: true
      t.string :comment

      t.timestamps null: false
    end
  end
end
