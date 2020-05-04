# frozen_string_literal: true

class List < ApplicationRecord
  has_many :items, -> { order(id: :asc) }, dependent: :delete_all, inverse_of: :list
  belongs_to :workspace

  validates :name, presence: true, length: {maximum: 255}
end
