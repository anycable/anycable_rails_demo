# frozen_string_literal: true

Rails.application.routes.draw do
  resources :workspaces, only: [:index, :new, :create, :destroy, :show], param: :public_id

  root to: "workspaces#index"
end
