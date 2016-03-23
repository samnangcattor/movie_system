class AddRedirectNewToLink < ActiveRecord::Migration
  def change
    add_column :links, :redirect_url, :boolean
  end
end
