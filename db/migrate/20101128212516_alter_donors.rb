class AlterDonors < ActiveRecord::Migration
  def self.up
    change_table :donors do |t|
      t.remove :cd_requested
      t.boolean :cd_requested, :default => false
      t.index :confirmation_code
    end
  end

  def self.down
    change_table :donors do |t|
      t.remove_index :confirmation_code
      t.boolean :cd_requested
    end
  end
end
