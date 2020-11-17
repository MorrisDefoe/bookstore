Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount BookstoreApi::ApiV1 => '/'
  mount GrapeSwaggerRails::Engine => '/swagger'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :users do
        post 'create',      to: 'users#create',       on: :collection
        get 'active_users', to: 'users#active_users', on: :collection
        put 'makeAdmin',    to: 'users#make_admin',   on: :collection
      end

      resources :books do
        post 'addBook',    to: 'books#add_book',      on: :collection
        get 'findByGenre', to: 'books#find_by_genre', on: :collection
      end

      resources :order do
        post 'orderBook',    to: 'order#order_book',    on: :collection
        get 'showOrders',    to: 'order#show_orders',   on: :collection
        put 'changeStatus',  to: 'order#change_status', on: :collection
      end
    end
  end


end
