Rails.application.routes.draw do
  devise_for :users, controllers:{
    registrations: 'users/registrations'
  }
  
  # Routes for normal users to view products and home page
  root 'products#index'
  resources :products, only: [:index, :show]
  
  # Routes for managing the shopping cart
  resource :cart, only: [:show, :create, :destroy] do
    post 'add_to_cart', as: 'add_to_cart_cart'
    post 'update_quantity', on: :member
    delete 'remove_from_cart', on: :member
    get 'checkout', on: :collection
    post 'complete_checkout', as: 'complete_checkout', on: :collection
    get 'calculate_taxes', on: :collection 
  end 

  resources :orders do
    get 'confirmation', on: :member
  end
  
  # Routes for admin categories management
  namespace :admin do
    resources :categories 
  end

  # Routes for admin sessions
  get '/admin/login', to: 'admin_sessions#new', as: 'new_admin_session'
  post '/admin/login', to: 'admin_sessions#create', as: 'admin_sessions'
  delete '/admin/logout', to: 'admin_sessions#destroy', as: 'destroy_admin_session'

  # Routes for admin dashboard and product management
  scope '/admin' do
    get '/dashboard', to: 'admin#dashboard', as: 'admin_dashboard'
    get '/new_product', to: 'admin#new_product', as: 'new_product_admin'
    post '/create_product', to: 'admin#create_product', as: 'create_product_admin'
    get '/edit_product/:id', to: 'admin#edit_product', as: 'edit_product_admin'
    patch '/update_product/:id', to: 'admin#update_product', as: 'update_product_admin'
    delete '/delete_product/:id', to: 'admin#delete_product', as: 'delete_product_admin'
    get '/index', to: 'admin#index', as: 'admin_index'
    get '/products/:id', to: 'admin#show_product', as: 'show_product_admin'
    get '/admin/list_users_with_orders', to: 'admin#list_users_with_orders'
  end

  resources :categories, as: "categories"

  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
