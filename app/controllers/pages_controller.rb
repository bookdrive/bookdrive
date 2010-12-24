class PagesController < ApplicationController
  filter_access_to :all

  caches_page :home, :about, :faq, :usedbooks, :press, :cookies
  
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
    "up.browser",
    "up.link",
    "mmp",
    "symbian",
    "smartphone",
    "midp",
    "wap",
    "vodafone",
    "o2",
    "pocket",
    "kindle",
    "mobile",
    "pda",
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
