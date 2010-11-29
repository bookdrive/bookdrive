class Donor < ActiveRecord::Base
  has_many :download_events
  
  validates_presence_of :confirmation_code, :message => "You must enter your order number before submitting the form!"
  validates_format_of :confirmation_code, :with => /\A\d{3}-?\d{7}-?\d{7}\Z/, :message => "Oops! This is not a valid order number. Try to copy and paste it from your confirmation email again."
  validates_uniqueness_of :confirmation_code, :message => "I'm sorry, the order number you entered has already been used on another computer. If you believe this is an error, please email us at richmondbookdrive@gmail.com."

#  validates_presence_of :full_name, :if => :should_validate_address?
#  validates_format_of :full_name, :with => /\A\w+\s\w+\Z/, :if => :should_validate_address?

#  validates_presence_of :address1, :if => :should_validate_address?
#  validates_presence_of :city, :if => :should_validate_address?
#  validates_presence_of :state, :if => :should_validate_address?
#  validates_presence_of :zip, :if => :should_validate_address?
#  validates_format_of :zip, :with => /\A\d{5}(-\d{4})?\Z/, :if => :should_validate_address?

  has_friendly_id :confirmation_code
#  attr_accessor :saving_address
  
  before_create :format_confirmation_code, :generate_donor_code

#  def should_validate_address?
#    saving_address || self.cd_requested?
#  end
  

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
