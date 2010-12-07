class AddDollarsDonatedToBooks < ActiveRecord::Migration
  def self.up
    add_column :books, :dollars_donated, :decimal
  end

  def self.down
    remove_column :books, :dollars_donated
  end
end
