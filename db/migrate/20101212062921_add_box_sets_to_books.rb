class AddBoxSetsToBooks < ActiveRecord::Migration
  def self.up
    add_column :books, :books_in_set, :integer, :default => 1
    add_column :books, :total_book_count, :integer, :default => 0
    Book.all.each do |b|
      b.save
    end
  end

  def self.down
    remove_column :books, :total_book_count
    remove_column :books, :books_in_set
  end
end
