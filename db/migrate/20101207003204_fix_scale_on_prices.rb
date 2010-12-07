class FixScaleOnPrices < ActiveRecord::Migration
  def self.up
    change_table :books do |t|
      t.change :amazon_price, :decimal, :precision => 10, :scale => 2
      t.change :amazon_strike_price, :decimal, :precision => 10, :scale => 2
      t.change :dollars_donated, :decimal, :precision => 10, :scale => 2
    end
  end

  def self.down
  end
end
