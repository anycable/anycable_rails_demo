# frozen_string_literal: true

class Item < ApplicationRecord
  validates :desc, presence: true

  belongs_to :list

  scope :completed, -> { where(completed: true) }
end
