class CreateProgressStatuses < ActiveRecord::Migration
  def change
    create_table :progress_statuses do |t|
      t.integer :progress_name
      t.integer :status_progress, default: 0
      t.float :progress, default: 0
      t.float :remaining_time, default: 0
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps null: false
    end
  end
end
