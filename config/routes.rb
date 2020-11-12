Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount BookstoreApi::ApiV1 => '/'
  mount GrapeSwaggerRails::Engine => '/swagger'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users
  resources :books
  resources :order
  post 'api/v1/users/create', to: 'users#create'
  get 'api/v1/users/:id/show', to: 'users#show'
  get 'api/v1/users/active_users', to: 'users#active_users'
  put 'api/v1/users/makeAdmin', to: 'users#make_admin'
  post 'api/v1/books/addBook', to: 'books#add_book'
  get 'api/v1/books/findByGenre', to: 'books#find_by_genre'
  post 'api/v1/order/orderBook', to: 'order#order_book'
  get 'api/v1/order/showOrders', to: 'order#show_orders'
  put 'api/v1/order/changeStatus', to: 'order#change_status'
end
