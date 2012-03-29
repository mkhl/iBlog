Iblog::Application.routes.draw do
  resources :blogs do
    resources :entries
  end

  get '/index-all' => 'entries#full'

  root :to => 'blogs#index'

  # map.with_options :controller => 'entries' do |entries|
  #   entries.tag '/tags/:tag.:format', :action => 'index'
  #   entries.user_home '/home/:author.:format', :action => 'user_home'
  #   entries.home '/home', :action => 'home'
  # end
  # map.with_options :controller => 'admin' do |admin|
  #   admin.index '/admin',     :action => 'index'
  #   admin.log   '/admin/log', :action => 'log'
  #   admin.env   '/admin/env', :action => 'env'
  # end
end
