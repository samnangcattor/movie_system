class AddAppexToLink < ActiveRecord::Migration
  def change
    add_column :links, :status_appex, :integer, default: 0
  end
end
