class AddFileProgressToDownload < ActiveRecord::Migration
  def change
    add_column :downloads, :file_progress, :integer, default: 0
  end
end
