class CreateDownloadEvents < ActiveRecord::Migration
  def self.up
    create_table :download_events do |t|
      t.integer :donor_id
      t.integer :gift_id

      t.timestamps
    end
  end

  def self.down
    drop_table :download_events
  end
end
