class FixAuthorColumn < ActiveRecord::Migration
  def self.up
    change_column :books, :author, :string
  end

  def self.down
  end
end
