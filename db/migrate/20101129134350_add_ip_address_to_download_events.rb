class AddIpAddressToDownloadEvents < ActiveRecord::Migration
  def self.up
    add_column :download_events, :ip_address, :string
  end

  def self.down
    remove_column :download_events, :ip_address
  end
end
