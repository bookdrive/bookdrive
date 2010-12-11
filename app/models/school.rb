class School < ActiveRecord::Base

  validates_presence_of :name
  validates_presence_of :level
  validates_uniqueness_of :name
  validates_numericality_of :students, :greater_than_or_equal_to => 0, :only_integer => true
  validates_numericality_of :proficiency, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  validates_numericality_of :lunch_eligibility, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  
  
  
  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  
end
