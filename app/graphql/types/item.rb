# frozen_string_literal: true

module Types
  class Item < GraphQL::Schema::Object
    field :id, ID, null: false
    field :description, String, method: :desc, null: false
    field :completed, Boolean, null: false
  end
end
