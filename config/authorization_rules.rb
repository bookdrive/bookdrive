authorization do
  role :admin do
    includes :support, :editor, :catalogger
    has_permission_on :users, :to => [:dominate]
    has_permission_on :books, :to => [:dominate]
    has_permission_on :press, :to => [:dominate]
    has_permission_on :gifts, :to => [:dominate]
    has_permission_on :donors, :to => [:dominate]
    has_permission_on :download_events, :to => [:dominate]
  end

  role :support do
    has_permission_on :donors, :to => [:dominate]
  end

  role :editor do
    has_permission_on :press, :to => [:manage]
  end

  role :catalogger do
    has_permission_on :books, :to => [:manage]
  end
  
  role :guest do
    has_permission_on :press, :to => [:browse]
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
