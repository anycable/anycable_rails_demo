# frozen_string_literal: true

module Types
  class Root < GraphQL::Schema::Object
    graphql_name "Query"

    field :workspace, Workspace, null: false do
      argument :id, ID, required: true
    end

    field :random_workspaces, [Workspace], null: false

    def workspace(id:)
      ::Workspace.preload(lists: :items).find_by!(public_id: id)
    end

    def random_workspaces
      ::Workspace.order("RANDOM()").limit(2)
    end
  end
end
