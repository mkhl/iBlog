Iblog::Application.routes.draw do
  resources :blogs do
    resources :entries
  end

  get '/index-all' => 'entries#full', :as => 'entries'

  root :to => 'blogs#index'

  scope '/entries' do
    get '/tags/:tag(.:format)' => 'entries#by_tag', :as => 'tag'
    get '/home/:author(.:format)' => 'entries#user_home', :as => 'blog_entries_by_author'
    get '/home' => 'entries#home', :as => 'home'
  end

  scope '/admin' do
    get '/' => 'admin#index'
    get '/log' => 'admin#log'
    get '/env' => 'admin#env'
  end

  get '/blogs/by/:owner(.:format)' => 'blogs#index', :as => 'blogs_by_owner'

end
