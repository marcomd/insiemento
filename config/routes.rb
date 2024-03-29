Rails.application.routes.draw do
  root 'users#index'

  get 'users', to: 'users#index'
  get 'users/*path', to: 'users#index'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # API guests frontend management
  namespace :api, defaults: { format: 'json' } do
    namespace :ui do
      namespace :v1 do
        devise_for :users, controllers: { registrations: 'api/ui/v1/registrations' }
        delete 'unregister', to: 'users#destroy'
        post 'authenticate', to: 'authentication#authenticate'
        get 'profile',        to: 'users#show'
        put 'profile',        to: 'users#update'
        get 'available/user', to: 'users#availability'
        resources :course_events do
          member do
            put 'subscribe'
            put 'audit'
            get 'attendees'
          end
        end
        resources :orders do
          member do
            put 'add_product/:product_id', to: 'orders#add_product', as: :add_product
            put 'remove_product/:product_id', to: 'orders#remove_product', as: :remove_product
          end
        end
        resources :payments, :products, :subscriptions
        put 'user_documents/callback/:uuid/:state', to: 'user_documents#callback'
        resources :news, only: :index
      end
    end
  end

  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  require 'sidekiq-status/web'
  authenticate :admin_user do
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  # mount ActionCable.server, at: '/cable'
  mount ActionCable.server => '/cable'
end
