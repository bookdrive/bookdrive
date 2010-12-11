class PagesController < ApplicationController
  filter_access_to :all

  caches_page :about, :faq, :usedbooks, :press, :thankyou
  
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
end
