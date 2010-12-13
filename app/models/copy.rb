class Copy < ActiveRecord::Base
  belongs_to :book, :counter_cache => 'copies_delivered'
  belongs_to :user
  
  def copy_count
    return 1
  end
  
  def copy_count=(copy_count)
  end
end
