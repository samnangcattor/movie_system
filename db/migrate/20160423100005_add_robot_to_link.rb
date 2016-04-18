class AddRobotToLink < ActiveRecord::Migration
  def change
    add_column :links, :robot, :boolean
  end
end
