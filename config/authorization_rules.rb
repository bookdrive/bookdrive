authorization do
  role :admin do
    includes :staff
    has_permission_on :users, :to => [:dominate]
    has_permission_on :books, :to => [:dominate]
    has_permission_on :copies, :to => [:dominate]
    has_permission_on :donors, :to => [:dominate]
    has_permission_on :gifts, :to => [:dominate]
    has_permission_on :download_events, :to => [:dominate]
    has_permission_on :schools, :to => [:dominate]
    has_permission_on :articles, :to => [:dominate]
    has_permission_on :questions, :to => [:dominate]
    
  end

  role :support do
    includes :staff
    has_permission_on :donors, :to => [:dominate]
  end

  role :content do
    includes :staff
    has_permission_on :press, :to => [:manage]
    has_permission_on :schools, :to => [:manage]
    has_permission_on :articles, :to => [:manage]
    has_permission_on :questions, :to => [:manage]
  end

  role :catalog do
    includes :staff
    has_permission_on :books, :to => [:manage]
    has_permission_on :copies, :to => [:manage]
  end
  
  role :staff do
    includes :guest
    has_permission_on :pages, :to => [:staff]
  end
  
  role :guest do
    has_permission_on :donors, :to => [:submit_registration, :downloads]
    has_permission_on :gifts, :to => [:download]
    has_permission_on :pages, :to => [:home, :usedbooks, :thankyou, :faq, :about, :press, :oops]
    has_permission_on :books, :to => [:update_wishlist]
  end
  
end


privileges do
  privilege :browse do
    includes :show, :index
  end
  
  privilege :manage, :includes => :browse do
    includes :new, :create, :edit, :update
  end
  
  privilege :dominate, :includes => :manage do
    includes :destroy
  end
end
