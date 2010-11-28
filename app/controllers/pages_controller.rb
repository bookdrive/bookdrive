class PagesController < ApplicationController
  def home
  end

  def thankyou
    @donor = Donor.new
  end
end
