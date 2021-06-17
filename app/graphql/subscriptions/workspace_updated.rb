# frozen_string_literal: true

module Subscriptions
  class WorkspaceUpdated < GraphQL::Schema::Subscription
    argument :id, ID, required: true

    field :workspace, Types::Workspace, null: false

    def subscribe(id:)
      workspace = Workspace.preload(lists: :items).find_by!(public_id: id)

      {workspace}
    end

    def update(*)
      {workspace: object}
    end
  end
end
