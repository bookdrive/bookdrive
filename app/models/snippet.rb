class Snippet < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :content
  
  def self.search(search)
    if search
      where('name ILIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  
end
