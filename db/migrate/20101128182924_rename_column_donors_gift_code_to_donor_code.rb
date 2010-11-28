class RenameColumnDonorsGiftCodeToDonorCode < ActiveRecord::Migration
  def self.up
    rename_column :donors, :gift_code, :donor_code
  end

  def self.down
    rename_column :donors, :donor_code, :gift_code
  end
end
