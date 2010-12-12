class DonorSweeper < ActionController::Caching::Sweeper
  observe Donor # This sweeper is going to keep an eye on the Donor model
 
  # If our sweeper detects that a Donor was created call this
  def after_create(donor)
          expire_cache_for(donor)
  end
 
  # If our sweeper detects that a Donor was updated call this
  #def after_update(product)
  #        expire_cache_for(product)
  #end
 
  # If our sweeper detects that a Donor was deleted call this
  def after_destroy(donor)
          expire_cache_for(donor)
  end
 
  private
  def expire_cache_for(donor)
    # Expire the home page now that we added a new donor
    expire_page(:controller => 'pages', :action => 'home')
 
    # Expire a fragment
    #expire_fragment('all_available_products')
  end
end