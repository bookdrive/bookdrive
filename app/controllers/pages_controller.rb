class PagesController < ApplicationController
  filter_access_to :all

  caches_page :home, :about, :faq, :usedbooks, :press, :cookies, :library
  
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
    @is_mobile = is_mobile?
  end
  
  def staff
  end

  def oops
  end

  def cookies_required
  end
  
  def offsite
    @p_url = params[:p_url]
    @p_title = params[:p_title]
  end

  def library
  end
  
  
  private
  
  MOBILE_BROWSERS = [
    "android",
    "ipod",
    "opera mini",
    "blackberry",
    "palm",
    "hiptop",
    "avantgo",
    "plucker",
    "xiino",
    "blazer",
    "elaine",
    "windows ce; ppc;",
    "windows ce; smartphone;",
    "windows ce; iemobile",
    "symbian",
    "smartphone",
    "vodafone",
    "pocket",
    "kindle",
    "mobile",
    "psp",
    "treo"
  ]

  def is_mobile?
    agent = request.env["HTTP_USER_AGENT"].downcase
    MOBILE_BROWSERS.each do |m|
      return true if agent.match(m)
    end
    return false
  end
  
end
