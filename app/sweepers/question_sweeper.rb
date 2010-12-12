class QuestionSweeper < ActionController::Caching::Sweeper
  observe Question # This sweeper is going to keep an eye on the Question model
 
  # If our sweeper detects that a question was created call this
  def after_create(question)
          expire_cache_for(question)
  end
 
  # If our sweeper detects that a question was updated call this
  def after_update(question)
          expire_cache_for(question)
  end
 
  # If our sweeper detects that a question was deleted call this
  def after_destroy(question)
          expire_cache_for(question)
  end
 
  private
  def expire_cache_for(question)
    # Expire the faq index now that we changed question
    expire_page(:controller => 'pages', :action => 'faq')
 
    # Expire a fragment
    #expire_fragment('all_available_products')
  end
end