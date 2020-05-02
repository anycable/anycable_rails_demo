# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  PAGE_SIZE = 20

  class << self
    def page(num)
      limit(PAGE_SIZE).offset((num - 1) * PAGE_SIZE)
    end
  end
end
