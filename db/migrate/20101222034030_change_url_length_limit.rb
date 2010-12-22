class ChangeUrlLengthLimit < ActiveRecord::Migration
  def self.up
    change_column :books, :amazon_product_url, :string, :limit => 1000
    change_column :books, :amazon_image_original_url, :string, :limit => 1000
    change_column :books, :amazon_image_url, :string, :limit => 1000
    change_column :books, :amazon_wl_cart_url, :string, :limit => 1000    
  end

  def self.down
    change_column :books, :amazon_product_url, :string
    change_column :books, :amazon_image_original_url
    change_column :books, :amazon_image_url, :string
    change_column :books, :amazon_wl_cart_url, :string   
  end
end
