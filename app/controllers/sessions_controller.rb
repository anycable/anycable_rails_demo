# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :redirect_logged_in, only: [:new, :create], if: :logged_in?
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
  end

  def create
    # Handle negative captcha by simply rerendering the form
    return render :new if params[:full_name].present?

    if params[:name].empty?
      flash.now[:alert] = "Name can't be blank"
      return render :new
    end

    redirect_back = session[:redirect_after_login]

    reset_user_session!

    user = User.generate(params[:name])
    commit_user_to_session! user

    redirect_to(redirect_back || root_path)
  end

  def destroy
    reset_user_session!

    redirect_back(fallback_location: root_path)
  end

  private

  def redirect_logged_in
    redirect_to root_path
  end
end
