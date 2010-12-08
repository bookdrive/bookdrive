class Book < ActiveRecord::Base
  validates_presence_of :title
  #validates_presence_of :author
  #validates_presence_of :amazon_image_width, :unless => "amazon_image_url.nil?||amazon_image_url.empty?"
  #validates_presence_of :amazon_image_height, :unless => "amazon_image_url.nil?||amazon_image_url.empty?"

  #validates_length_of :author, :minimum => 5
  validates_length_of :title, :minimum => 5
  
  validates_numericality_of :amazon_price, :greater_than_or_equal_to => 0, :allow_blank => true
  validates_numericality_of :copies_desired, :greater_than_or_equal_to => 0, :only_integer => true
  validates_numericality_of :copies_received, :greater_than_or_equal_to => 0, :only_integer => true
  #validates_numericality_of :amazon_image_width, :greater_than => 0, :only_integer => true, :allow_blank => true
  #validates_numericality_of :amazon_image_height, :greater_than => 0, :only_integer => true, :allow_blank => true
  
  has_many :copies, :dependent => :destroy
  belongs_to :user
  
  accepts_nested_attributes_for :copies, :allow_destroy => true
  
  def update_from_wl_book(wl_book)
    wl_book.attribute_hash().each do |key,value|
      send(key+'=',value)
    end
  end
  
  def self.search(search)
    if search
      where('title LIKE ? OR author LIKE ?', "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end

  
  
end
