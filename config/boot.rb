# frozen_string_literal: true

ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

return if RUBY_PLATFORM.match?(/wasm/)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.

# Use edge Ruby syntax
require "ruby-next/language"
require "ruby-next/language/rewriters/edge"
require "ruby-next/language/rewriters/proposed"
require "ruby-next/language/bootsnap"
