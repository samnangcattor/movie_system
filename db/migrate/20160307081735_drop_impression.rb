class DropImpression < ActiveRecord::Migration
  def change
    drop_table :impressions
  end
end
