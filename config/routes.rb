Rails.application.routes.draw do
  get '/scan' => 'application#scan'
  post '/groups/join'  => 'groups#join_group'
  post '/groups/leave' => 'groups#leave_group'

  resources :users do 
    resources :messages, only: [:index, :destroy]
    delete '/messages' => 'messages#destroy'
  end

  resources :groups
  resources :sessions

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'application#home'
  get '/auth/twitter', as: 'twitter_login'
  get '/auth/venmo', as: 'venmo_login'

  get '/venmo' => 'users#venmo'
  
  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match '/logout', to: 'sessions#destroy', via: [:get, :post]

  get 'groups/:id/closed' => 'groups#closed', as: "closed_group"
  get 'groups/:id/refund' => 'groups#refund', as: "refund_group"
  patch '/groups/:id/close' => 'groups#close', as: "close_group"


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
