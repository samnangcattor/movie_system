class AddSuggestionToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :suggestion, :boolean, default: false
  end
end
