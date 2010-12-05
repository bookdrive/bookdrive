class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.string :title, :null => false
      t.string :author, :null => false
      t.decimal :price
      t.integer :copies_desired, :default => 0
      t.integer :copies_received, :default => 0
      t.boolean :copies_complete, :default => false
      t.string :amazon_product_url
      t.string :amazon_wl_cart_url
      t.string :amazon_image_url
      t.integer :amazon_image_width
      t.integer :amazon_image_height
      t.string :amazon_cover_type
      t.date :amazon_wl_add_date
      t.string :source
      t.timestamps
    end
  end

  def self.down
    drop_table :books
  end
end
