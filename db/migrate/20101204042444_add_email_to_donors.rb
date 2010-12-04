class AddEmailToDonors < ActiveRecord::Migration
  def self.up
    add_column :donors, :email, :string
  end

  def self.down
    remove_column :donors, :email
  end
end
