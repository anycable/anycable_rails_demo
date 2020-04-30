# frozen_string_literal: true

class Workspace < ApplicationRecord
  validates :name, :public_id, presence: true, length: {maximum: 255}

  before_validation :assign_uniq_id, unless: :public_id

  def to_param
    public_id
  end

  private

  def assign_uniq_id
    self.public_id = Nanoid.generate(size: 6)
  end
end
