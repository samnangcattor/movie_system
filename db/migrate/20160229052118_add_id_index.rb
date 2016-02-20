class AddIdIndex < ActiveRecord::Migration
  def change
    add_index :movies, :id, unique: true
  end
end
