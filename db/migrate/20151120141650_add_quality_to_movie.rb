class AddQualityToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :quality, :integer, default: 0
  end
end
