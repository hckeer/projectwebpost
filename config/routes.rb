Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  get "about", to: "home#about"
  get "contact", to: "home#contact"
  post "toggle_theme", to: "home#toggle_theme"

  get "dashboard", to: "dashboard#index"

  resources :posts do
    member do
      post :publish
      post :archive
    end
  end

  namespace :admin do
    root "dashboard#index"

    resources :users do
      member do
        post :promote
        post :demote
      end
    end

    resources :posts do
      member do
        post :publish
        post :archive
      end
    end

    resources :categories
    resources :tags
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
