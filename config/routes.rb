Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  resources :users do
    member do
      post :clock_in, to: 'sleep_records#create'
      post :clock_out, to: 'sleep_records#update'
      get :sleep_records, to: 'sleep_records#index'

      post 'follow/:target_user_id', to: 'follows#create', as: :follow 
      delete 'follow/:target_user_id', to: 'follows#delete', as: :unfollow 

      get 'follow/sleep_records', to: 'sleep_records#following_sleep_records', as: :following_sleep_records

    end
  end

end
