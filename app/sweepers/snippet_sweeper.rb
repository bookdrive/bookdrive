class SnippetSweeper < ActionController::Caching::Sweeper
  observe Snippet # This sweeper is going to keep an eye on the Question model
 
  # If our sweeper detects that a question was created call this
  def after_create(snippet)
          expire_cache_for(snippet)
  end
 
  # If our sweeper detects that a question was updated call this
  def after_update(snippet)
          expire_cache_for(snippet)
  end
 
  # If our sweeper detects that a question was deleted call this
  def after_destroy(snippet)
          expire_cache_for(snippet)
  end
 
  private
  def expire_cache_for(question)
    # Expire the faq index now that we changed question
    expire_page(:controller => 'pages', :action => 'library')
    expire_page(:controller => 'pages', :action => 'home')
 
    # Expire a fragment
    expire_fragment('all_snippets')
  end
end