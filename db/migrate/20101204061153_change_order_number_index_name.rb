class ChangeOrderNumberIndexName < ActiveRecord::Migration
  def self.up
    remove_index :donors, :confirmation_code
    add_index :donors, :order_number
  end

  def self.down
    remove_index :donors, :order_number
    add_index :donors, :confirmation_code
  end
end
