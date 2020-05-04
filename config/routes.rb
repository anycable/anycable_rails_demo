# frozen_string_literal: true

Rails.application.routes.draw do
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
