# frozen_string_literal: true

module Types
  class List < GraphQL::Schema::Object
    field :id, ID, null: false
    field :name, String, null: false
    field :items, [Item], null: false
  end
end
