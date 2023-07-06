# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

namespace :heroku do
  task release: ["db:migrate"] do
    # Seed database if empty
    if Workspace.count.zero?
      load "./db/seeds.rb"
    end

    # Wait for Litestream to catch up
    sleep 5
  end
end
