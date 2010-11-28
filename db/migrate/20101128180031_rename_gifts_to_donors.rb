class RenameGiftsToDonors < ActiveRecord::Migration
  def self.up
    rename_table :gifts, :donors
    rename_table :downloads, :gifts
  end

  def self.down
    rename_table :gifts, :downloads
    rename_table :donors, :gifts
  end
end
