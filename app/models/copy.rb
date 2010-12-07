class Copy < ActiveRecord::Base
  belongs_to :book, :counter_cache => 'copies_delivered'
  belongs_to :user
end
