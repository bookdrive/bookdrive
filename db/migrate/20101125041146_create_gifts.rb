class CreateGifts < ActiveRecord::Migration
  def self.up
    create_table :gifts do |t|
      t.string :confirmation_code
      t.string :zip
      t.string :gift_code

      t.timestamps
    end
  end

  def self.down
    drop_table :gifts
  end
end
