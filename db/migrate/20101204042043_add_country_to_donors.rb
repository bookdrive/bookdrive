class AddCountryToDonors < ActiveRecord::Migration
  def self.up
    add_column :donors, :country, :string
  end

  def self.down
    remove_column :donors, :country
  end
end
