class Gift < ActiveRecord::Base
  validates_presence_of :confirmation_code, :zip
  validates_format_of :confirmation_code, :with => /\A\d{3}-?\d{7}-?\d{7}\Z/
  validates_format_of :zip, :with => /\A(\d{5})(-\d{4})?\Z/

  def generate_uuid
    time = Time.now.to_i.to_s(16).upcase
    self.gift_code = Digest::MD5.hexdigest("#{self.confirmation_code}#{time}")
  end
  
end
