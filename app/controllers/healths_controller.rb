# frozen_string_literal: true

class HealthsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    head :ok
  end
end
