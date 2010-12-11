class ArticlesSweeper < ActionController::Caching::Sweeper
  observe Article # This sweeper is going to keep an eye on the Article model
 
  # If our sweeper detects that a Press was created call this
  def after_create(article)
          expire_cache_for(article)
  end
 
  # If our sweeper detects that a Press was updated call this
  def after_update(article)
          expire_cache_for(article)
  end
 
  # If our sweeper detects that a Press was deleted call this
  def after_destroy(article)
          expire_cache_for(article)
  end
 
  private
  def expire_cache_for(article)
    # Expire the pres index now that we changed article
    expire_page(:controller => 'pages', :action => 'press')
 
    # Expire a fragment
    #expire_fragment('all_available_products')
  end
end