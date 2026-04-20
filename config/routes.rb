# frozen_string_literal: true

Rails.application.routes.draw do
  # App boot health check
  get "/up", to: "rails/health#show", as: :rails_health_check

  get "/login", to: "sessions#new", as: :login
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  resources :workspaces, only: [:index, :new, :create, :destroy, :show] do
    resources :lists, only: [:create, :destroy] do
      resources :items, only: [:create, :destroy, :update]
    end
  end

  root to: "workspaces#index"
end
