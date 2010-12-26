class SchoolSweeper < ActionController::Caching::Sweeper
  observe School # This sweeper is going to keep an eye on the school model
 
  # If our sweeper detects that a school was created call this
  def after_create(school)
          expire_cache_for(school)
  end
 
  # If our sweeper detects that a school was updated call this
  def after_update(school)
          expire_cache_for(school)
  end
 
  # If our sweeper detects that a school was deleted call this
  def after_destroy(school)
          expire_cache_for(school)
  end
 
  private
  def expire_cache_for(school)
    # Expire the about page now that we changed school
    expire_page(:controller => 'pages', :action => 'about')
    expire_fragment('schoolstats')
    
    # Expire a fragment
    #expire_fragment('all_available_products')
  end
end
