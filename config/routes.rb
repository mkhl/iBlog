ActionController::Routing::Routes.draw do |map|
  map.resources :blogs

  map.resources :entries
  map.root :controller => 'entries'   
  map.with_options :controller => 'entries' do |entries|
    entries.tag '/tags/:tag', :action => 'index'
    entries.user_home '/home/:author', :action => 'index'
    entries.home '/home', :action => 'home'
  end
  map.with_options :controller => 'admin' do |admin|
    admin.index '/admin',     :action => 'index'
    admin.log   '/admin/log', :action => 'log'
    admin.env   '/admin/env', :action => 'env'
  end
end
