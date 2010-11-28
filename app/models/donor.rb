class Donor < ActiveRecord::Base
  validates_presence_of :confirmation_code
  validates_format_of :confirmation_code, :with => /\A\d{3}-?\d{7}-?\d{7}\Z/
  validates_uniqueness_of :confirmation_code
  
  has_friendly_id :confirmation_code
  
  before_create :format_confirmation_code, :generate_donor_code

  private
  
  def generate_donor_code
    time = Time.now.to_i.to_s(16).upcase
    self.donor_code = Digest::MD5.hexdigest("#{self.confirmation_code}#{time}")
  end
  
  def format_confirmation_code
    if ( self.confirmation_code !~ /-\d+-/ )
      self.confirmation_code.sub!(/(\d{3})-?(\d{7})-?(\d{7})/, '\1-\2-\3')
    end
  end
  
end
