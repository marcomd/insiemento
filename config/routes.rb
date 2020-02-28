Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'users', to: 'users#index'
  get 'users/*path', to: 'users#index'

  # API guests frontend management
  namespace :api, defaults: { format: 'json' } do
    namespace :ui do
      namespace :v1 do
        devise_for :users, controllers: {registrations: 'api/ui/v1/registrations' }
        delete 'unregister', to: 'users#destroy'
        post 'authenticate', to: 'authentication#authenticate'
        get 'profile',        to: 'users#show'
        put 'profile',        to: 'users#update'
        get 'available/user', to: 'users#availability'
        resources :course_events do
          member do
            put 'subscribe'
          end
        end
      end
    end
  end

  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  require 'sidekiq-status/web'
  authenticate :admin_user do
    mount Sidekiq::Web => '/admin/sidekiq'
  end

end
