class Book < ActiveRecord::Base
  validates_presence_of :title
  
  validates_numericality_of :amazon_price, :greater_than_or_equal_to => 0, :allow_blank => true
  validates_numericality_of :copies_desired, :greater_than_or_equal_to => 0, :only_integer => true
  validates_numericality_of :copies_received, :greater_than_or_equal_to => 0, :only_integer => true
  
  has_many :copies, :dependent => :destroy
  belongs_to :user
  
  accepts_nested_attributes_for :copies, :allow_destroy => true
  
  before_save :calculate_dollars
  before_create :calculate_dollars
  before_save :calculate_total_book_count
  before_create :calculate_total_book_count
  before_save :determine_complete
  before_create :determine_complete
  before_save :determine_set
  before_create :determine_set
  before_save :trim_refs_from_urls
  before_create :trim_refs_from_urls
  
  def update_from_wl_book(wl_book)
    wl_book.attribute_hash().each do |key,value|
      
      old_value = send(key)
      
      if key.to_s == 'amazon_wl_add_date'
        if  old_value.to_formatted_s(:long).sub(/\s\s/,' ') != value.to_s
          logger.debug 'add_date: ' + old_value.to_formatted_s(:long).sub(/\s\s/,' ')
          logger.debug 'add_date: ' + value.to_s + "\n"
          send(key+'=',value)
        end
      elsif old_value.to_s != value.to_s
        logger.debug key + ': ' + old_value.to_s
        logger.debug key + ': ' + value.to_s + "\n"
        send(key+'=',value)
      end
    end
  end
  
  def self.search(search)
    if search
      where('title LIKE ? OR author LIKE ?', "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end
  
  private
  
  def determine_set
    if self.title =~ /Books 1(?:-| to )(\d+)/ || self.title =~ /(\d+) Book Box Set/
      self.books_in_set = $1
    end    
  end
  
  def determine_complete
    if self.copies_received >= self.copies_desired
      self.copies_complete = true
    end
  end
  
  def calculate_dollars  
    copies = self.copies_delivered > self.copies_received ? self.copies_delivered : self.copies_received
    price = self.amazon_price && self.amazon_price > 0.00 ? self.amazon_price : 0.00
    self.dollars_donated = self.amazon_price.to_f * copies.to_i
  end

  def calculate_total_book_count
    copies = self.copies_delivered > self.copies_received ? self.copies_delivered : self.copies_received
    self.total_book_count = self.books_in_set * copies
  end
  
  def trim_refs_from_urls
    if self.amazon_product_url.present?
      self.amazon_product_url.sub!(/ref=.+?\/[\d\-]+/,'')
    end
    if self.amazon_wl_cart_url.present?
      self.amazon_wl_cart_url.sub!(/ref=.+?\/[\d\-]+/,'')
    end
  end  
  
end
