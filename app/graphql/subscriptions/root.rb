# frozen_string_literal: true

module Subscriptions
  class Root < GraphQL::Schema::Object
    graphql_name "Subscription"

    field :workspace_updated, subscription: WorkspaceUpdated
  end
end
