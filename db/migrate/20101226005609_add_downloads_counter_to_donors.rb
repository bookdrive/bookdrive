class AddDownloadsCounterToDonors < ActiveRecord::Migration
  def self.up
    add_column :donors, :downloads_count, :integer, :default => 0
  end

  def self.down
    remove_column :donors, :downloads_count
  end
end
