# frozen_string_literal: true

Rails.application.routes.draw do
  resources :workspaces, only: [:index, :new, :create, :destroy, :show]

  root to: "workspaces#index"
end
