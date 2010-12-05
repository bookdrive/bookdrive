class CreatePress < ActiveRecord::Migration
  def self.up
    create_table :press do |t|
      t.string :title
      t.text :summary
      t.string :source
      t.string :url
      t.date :date
      t.string :author
      t.text :embed
      
      t.timestamps
    end
  end

  def self.down
    drop_table :press
  end
end
