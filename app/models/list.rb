# frozen_string_literal: true

class List < ApplicationRecord
  validates :name, presence: true, length: {maximum: 255}

  belongs_to :workspace
end
