Rails.application.routes.draw do
  get '/users', to: 'users#index', :defaults => { :format => 'json' }
  get '/users/:id', to: 'users#get_by_id', :defaults => { :format => 'json' }
  post '/users', to: 'users#create', :defaults => { :format => 'json' }
  put '/users/:id', to: 'users#update', :defaults => { :format => 'json' }
  delete '/users/:id', to: 'users#delete', :defaults => { :format => 'json' }

  resources :posts, only: %i[create update delete], defaults: { :format => 'json' }
end
