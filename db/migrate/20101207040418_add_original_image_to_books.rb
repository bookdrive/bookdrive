class AddOriginalImageToBooks < ActiveRecord::Migration
  def self.up
    add_column :books, :amazon_image_original_url, :string
  end

  def self.down
    remove_column :books, :amazon_image_original_url
  end
end
