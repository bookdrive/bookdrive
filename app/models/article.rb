class Article < ActiveRecord::Base
  def self.search(search)
    if search
      where('title ILIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  
end
