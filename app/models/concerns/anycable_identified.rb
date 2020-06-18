# frozen_string_literal: true

module AnycableIdentified
  extend ActiveSupport::Concern

  include GlobalID::Identification

  class_methods do
    def find_by_gid(gid) = new(gid.params)
  end

  def to_global_id(options = {})
    super(attributes.merge!(options).merge!(app: :anycable))
  end

  alias to_gid to_global_id
end

# Setup GlobalID to correctly resolve our custom identification
GlobalID::Locator.use :anycable do |gid|
  gid.model_name.constantize.find_by_gid(gid) # rubocop:disable Rails/DynamicFindBy
end
