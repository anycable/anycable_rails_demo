# frozen_string_literal: true

# Provide utils for a simple authentication
module Authenticated
  extend ActiveSupport::Concern

  included do
    next unless respond_to?(:helper_method)

    helper_method :current_user
    helper_method :logged_in?
  end

  def current_user
    return @current_user if instance_variable_defined?(:@current_user)

    @current_user = login_from_session || login_from_cookie
  end

  def logged_in?() = !current_user.nil?

  private

  def login_from_session
    return unless session[:name]
    User.new(name: session[:name], id: session[:id])
  end

  def login_from_cookie
    return unless cookies[:uid]

    name, id = cookies[:uid].split("/")
    User.new({name, id}).tap do |user|
      # store in session
      commit_user_to_session! user
    end
  end

  def reset_user_session!
    cookies.delete(:uid, domain: :all)
    reset_session
  end

  def commit_user_to_session!(user)
    session[:name] = user.name
    session[:id] = user.id
    cookies[:uid] = {value: "#{user.name}/#{user.id}", domain: :all}
  end
end
