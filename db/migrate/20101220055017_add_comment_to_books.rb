class AddCommentToBooks < ActiveRecord::Migration
  def self.up
    add_column :books, :amazon_wl_comment, :text
  end

  def self.down
    remove_column :books, :amazon_wl_comment
  end
end
