class AddAddressToDonor < ActiveRecord::Migration
  def self.up
    change_table :donors do |t|
      t.string :full_name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.boolean :cd_requested
    end
  end

  def self.down
    change_table :donors do |t|
      t.remove :full_name, :address1, :address2, :city, :state, :cd_requested
    end
  end
end
