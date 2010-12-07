class ApplicationController < ActionController::Base
  protect_from_forgery
  #before_filter { |c| Authorization.current_user = c.current_user }
  
  protected

  def permission_denied
    redirect_to root_url, :alert => "Sorry, you are not allowed to access that page."
  end
  
  private
  
  def confirm_donor
    order_number = params[:donor_id] || params[:id]
    if order_number !~ /-\d+-/
      order_number.sub!(/(\d{3})-?(\d{7})-?(\d{7})/, '\1-\2-\3')
    end
    
    @donor = Donor.find_by_order_number( order_number )
    if user_signed_in?
      return
    end
    donor_code = cookies['donor_' + order_number]
    logger.debug donor_code
    #logger.debug @donor.donor_code
    if !@donor || !donor_code || donor_code != @donor.donor_code
      redirect_to thankyou_path, :alert => "The order number you entered has already been used on another computer."
    end
  end

end
