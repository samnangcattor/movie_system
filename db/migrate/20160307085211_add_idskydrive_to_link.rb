class AddIdskydriveToLink < ActiveRecord::Migration
  def change
    add_column :links, :cid, :string
    add_column :links, :sky_id, :string
    add_column :links, :authkey, :string
  end
end
