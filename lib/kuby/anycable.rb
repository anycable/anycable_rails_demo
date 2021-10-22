# frozen_string_literal: true

require "kuby"
require "kuby/anycable/plugin"

Kuby.register_plugin(:anycable, Kuby::AnyCable::Plugin)
