# frozen_string_literal: true

module Types
  class Workspace < GraphQL::Schema::Object
    field :id, ID, null: false, method: :public_id
    field :name, String, null: false
    field :lists, [List], null: false
  end
end
