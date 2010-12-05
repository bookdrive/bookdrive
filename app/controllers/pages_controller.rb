class PagesController < ApplicationController
  caches_page :home, :schools, :faq, :usedbooks, :thankyou
  
  def home
  end

  def schools
  end

  def faq
  end

  def usedbooks
  end

  def thankyou
    @donor = Donor.new
  end
end
