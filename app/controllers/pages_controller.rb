class PagesController < ApplicationController
  def home
  end

  def thankyou
    @gift = Gift.new
  end
end
