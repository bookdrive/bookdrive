class PagesController < ApplicationController
  filter_access_to :all

  caches_page :home, :about, :faq, :usedbooks, :press, :thankyou
  
  def home
  end

  def about
  end

  def faq
  end

  def press
  end

  def usedbooks
  end

  def thankyou
    @donor = Donor.new
  end
  
  def staff
  end

  def oops
  end
  
end
