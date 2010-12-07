class AddCopiesDeliveredToBooks < ActiveRecord::Migration
  def self.up
    add_column :books, :copies_delivered, :integer, :default => 0
  end

  def self.down
    remove_column :books, :copies_delivered
  end
end
