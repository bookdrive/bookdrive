class Gift < ActiveRecord::Base
  has_many :download_events
  
  validates_presence_of :name, :message => "You must include a name that will appear in the list of downloads"
#  validates_presence_of :attachment_file_name, :message => "You have to choose a file to upload"
  has_attached_file :attachment
  validates_attachment_presence :attachment
  validates_attachment_size :attachment, :greater_than => 10.kilobytes 
  
  
end
