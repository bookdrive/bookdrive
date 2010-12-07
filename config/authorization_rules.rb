authorization do
  role :admin do
    includes :guest
    has_permission_on :users, :to => [:dominate]
    has_permission_on :books, :to => [:dominate]
    has_permission_on :copies, :to => [:dominate]
    has_permission_on :press, :to => [:dominate]
    has_permission_on :donors, :to => [:dominate]
    has_permission_on :gifts, :to => [:dominate]
    has_permission_on :download_events, :to => [:dominate]
  end

  role :support do
    includes :guest
    has_permission_on :donors, :to => [:dominate]
  end

  role :content do
    includes :guest
    has_permission_on :press, :to => [:manage]
  end

  role :catalog do
    includes :guest
    has_permission_on :books, :to => [:manage]
    has_permission_on :copies, :to => [:manage]
  end
  
  role :guest do
    has_permission_on :press, :to => [:browse]
    has_permission_on :donors, :to => [:submit_registration, :downloads]
    has_permission_on :gifts, :to => [:download]
    has_permission_on :pages, :to => [:home, :usedbooks, :thankyou, :faq, :about]
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
