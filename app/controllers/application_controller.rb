# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Authenticated
  include CableReady::Broadcaster

  before_action :authenticate_user!, unless: :logged_in?

  private

  def authenticate_user!
    session[:redirect_after_login] = request.url
    redirect_to(login_path)
  end

  def render_partial(path, locals = {})
    render_to_string(partial: path, formats: [:html], layout: false, locals: locals)
  end
end
