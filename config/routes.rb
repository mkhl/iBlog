ActionController::Routing::Routes.draw do |map|
  map.resources :entries
  map.root :controller => 'entries'   
  map.with_options :controller => 'entries' do |entries|
    entries.home '/home', :action => 'home'
    entries.user_home '/home/:author', :action => 'index'
  end
  map.with_options :controller => 'admin' do |admin|
    admin.index '/admin',     :action => 'index'
    admin.log   '/admin/log', :action => 'log'
    admin.env   '/admin/env', :action => 'env'
  end
end
