class PressSweeper < ActionController::Caching::Sweeper
  observe Press # This sweeper is going to keep an eye on the Press model
 
  # If our sweeper detects that a Press was created call this
  def after_create(press)
          expire_cache_for(press)
  end
 
  # If our sweeper detects that a Press was updated call this
  def after_update(press)
          expire_cache_for(press)
  end
 
  # If our sweeper detects that a Press was deleted call this
  def after_destroy(press)
          expire_cache_for(press)
  end
 
  private
  def expire_cache_for(press)
    # Expire the pres index now that we changed press
    expire_page(:controller => 'press', :action => 'index')
 
    # Expire a fragment
    #expire_fragment('all_available_products')
  end
end