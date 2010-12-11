class Question < ActiveRecord::Base
  validates_presence_of :question
  validates_presence_of :category
  validates_presence_of :answer
  validates_uniqueness_of :question
  
  def self.search(search)
    if search
      where('question LIKE ?', "%#{search}%")
    else
      scoped
    end
  end

end
