class PagesController < ApplicationController
  def home
  end

  def schools
  end

  def usedbooks
  end

  def thankyou
    @donor = Donor.new
  end
end
