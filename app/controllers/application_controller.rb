class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  
  def confirm_donor
    confirmation_code = params[:donor_id] || params[:id]
    @donor = Donor.find_by_confirmation_code( confirmation_code )
    if user_signed_in?
      return
    end
    donor_code = cookies['donor_' + confirmation_code]
    if !@donor || !donor_code || donor_code != @donor.donor_code
      redirect_to thankyou_path, :alert => "You must have registered a valid confirmation code from this computer"
    end
  end

end
