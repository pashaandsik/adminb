# frozen_string_literal: true
Admin::Engine.routes.draw do
  root to: "home#index"
  get  "/login"   => "sessions#new"
  post "/login"   => "sessions#create"
  post "/logout"  => "sessions#destroy"
  get "/home"     => "home#index"

  resources :admin_users, except: %i[show destroy] do
    get :abilities, on: :collection
  end
end
