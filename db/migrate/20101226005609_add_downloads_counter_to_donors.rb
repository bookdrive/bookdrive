class AddDownloadsCounterToDonors < ActiveRecord::Migration
  def self.up
    add_column :donors, :downloads_count, :integer, :default => 0
    
    Donor.all.each do |donor|
      puts donor.order_number + ": " + donor.download_events.count.to_s
      donor.downloads_count = donor.download_events.count
      puts donor.downloads_count
      donor.save!
      puts donor.downloads_count
    end
  end

  def self.down
    remove_column :donors, :downloads_count
  end
end
