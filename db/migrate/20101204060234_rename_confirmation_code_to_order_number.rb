class RenameConfirmationCodeToOrderNumber < ActiveRecord::Migration
  def self.up
    rename_column :donors, :confirmation_code, :order_number
  end

  def self.down
    rename_column :donors, :order_number, :confirmation_code
  end
end
