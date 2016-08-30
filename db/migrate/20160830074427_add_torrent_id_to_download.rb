class AddTorrentIdToDownload < ActiveRecord::Migration
  def change
    add_column :downloads, :torrent, :integer
  end
end
