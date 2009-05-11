ActionController::Routing::Routes.draw do |map|
  map.resources :entries
  map.root :controller => 'entries'
  map.with_options :controller => 'admin' do |admin|
    admin.index '/admin',     :action => 'index'
    admin.log   '/admin/log', :action => 'log'
    admin.env   '/admin/env', :action => 'env'
  end
end
