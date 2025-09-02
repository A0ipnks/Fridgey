Rails.application.routes.draw do
  resources :users, only: [:edit, :update]
  get "home/index"
  devise_for :users

  resources :rooms do
    member do
      post :join_by_code
    end
    collection do
      get :join
      post :join_by_code
    end

    # 各room内の食材を管理
    resources :food_items, except: [:index]
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end
