# frozen_string_literal: true

class ApplicationSchema < GraphQL::Schema
  use GraphQL::AnyCable, broadcast: true

  query Types::Root
  subscription Subscriptions::Root

  rescue_from(ActiveRecord::RecordNotFound) do |_exp|
    raise GraphQL::ExecutionError.new("Not found", extensions: {code: :not_found})
  end
end
