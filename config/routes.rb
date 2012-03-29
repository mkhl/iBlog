Iblog::Application.routes.draw do
  resources :blogs do
    resources :entries
  end

  get '/index-all' => 'entries#full'

  root :to => 'blogs#index'

  scope '/entries' do
    get '/tags/:tag(.:format)' => 'entries#index', :as => 'tag'
    get '/home/:author(.:format)' => 'entries#user_home', :as => 'user_home'
    get '/home' => 'entries#home', :as => 'home'
  end

  scope '/admin' do
    get '/' => 'admin#index'
    get '/log' => 'admin#log'
    get '/env' => 'admin#env'
  end
end
