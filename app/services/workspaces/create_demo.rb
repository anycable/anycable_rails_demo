# frozen_string_literal: true

module Workspaces
  module CreateDemo
    class << self
      def call(name: "Demo Workspace", public_id: nil, workspace: nil)
        ActiveRecord::Base.transaction do
          # We can use the existing workspace to populate demo data
          demo = workspace || Workspace.create!({name, public_id})

          # First list
          demo.lists.create(name: "Migrate to AnyCable").tap do |list|
            list.items.completed.create(desc: "Add anycable-rails gem to a Gemfile")
            list.items.completed.create(desc: "Run rails g anycable:setup")
            list.items.create(desc: "Run compatibility checks")
            list.items.create(desc: "Make system tests pass")
            list.items.create(desc: "Deploy on staging")
            list.items.create(desc: "Promote to production")
          end

          # Second list
          demo.lists.create(name: "Try ACLI").tap do |list|
            list.items.create(desc: "Install ACLI from GitHub releases (https://github.com/palkan/acli)")
            list.items.create(desc: "Try to connect to the workspace from Terminal")
          end

          # Third list
          demo.lists.create(name: "Leave feedback").tap do |list|
            list.items.create(desc: "Star this repo: https://github.com/anycable/anycable_rails_demo")
            list.items.create(desc: "Share the work on Twitter #anycable")
            list.items.create(desc: "Leave an issue or a bug report :)")
          end
        end
      end
    end
  end
end
