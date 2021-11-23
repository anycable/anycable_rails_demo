# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require_relative "config/environment"

Rails.application.load_server

use Rack::Health, path: "/healthz"
run Rails.application
