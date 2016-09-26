class AddTransmissionToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :transmission, :integer
  end
end
