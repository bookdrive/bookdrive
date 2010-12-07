class RenameCataloggerToUser < ActiveRecord::Migration
  def self.up
    rename_column :copies, :catalogger_id, :user_id
  end

  def self.down
    rename_column :copies, :user_id, :catalogger_id
  end
end
