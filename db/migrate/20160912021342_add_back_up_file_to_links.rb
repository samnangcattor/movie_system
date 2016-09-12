class AddBackUpFileToLinks < ActiveRecord::Migration
  def change
    add_column :links, :file_back_up, :string
  end
end
