class AddIndexesForSearching < ActiveRecord::Migration
  def self.up
    add_index :questions, :question
    add_index :books, :title
    add_index :books, :author
    add_index :articles, :title
    add_index :schools, :name
  end

  def self.down
    remove_index :questions, :question
    remove_index :books, :title
    remove_index :books, :author
    remove_index :articles, :title
    remove_index :schools, :name
  end
end
