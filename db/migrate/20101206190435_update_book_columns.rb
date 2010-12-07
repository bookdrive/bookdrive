class UpdateBookColumns < ActiveRecord::Migration
  def self.up
    change_table :books do |t|
      t.rename :price, :amazon_price
      t.decimal :amazon_strike_price
      t.string :amazon_availability
      t.string :amazon_merchant
      t.string :amazon_wl_priority
    end
  end

  def self.down
    change_table :books do |t|
      t.rename_column :amazon_price, :prive
      t.remove_column :amazon_strike_price
      t.remove_column :amazon_availability
      t.remove_column :amazon_merchant
      t.remove_column :amazon_wl_priority
      
    end
  end
end
