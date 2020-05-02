# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Turbolinks::Redirection
  include Authenticated

  before_action :authenticate_user!, unless: :logged_in?

  private

  def authenticate_user!
    session[:redirect_after_login] = request.url
    redirect_to(login_path)
  end
end
