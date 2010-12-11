class RenamePressToArticle < ActiveRecord::Migration
  def self.up
    rename_table :press, :articles
  end

  def self.down
    rename_table :articles, :press
  end
end
