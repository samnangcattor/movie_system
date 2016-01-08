class AddSubToLink < ActiveRecord::Migration
  def change
    add_column :links, :subtitle, :text
  end
end
