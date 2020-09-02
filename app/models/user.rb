# frozen_string_literal: true

# Virtual model to represent current user in the app
class User
  include ActiveModel::Model
  include ActiveModel::Attributes
  include AnycableIdentified

  attribute :name, :string
  attribute :id, :string

  class << self
    def generate(name) = new({name, id: Nanoid.generate(size: 5)})
  end
end
