# frozen_string_literal: true

ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.

# Use edge Ruby syntax
require "ruby-next/language"
RubyNext::Language.mode = :rewrite

require "ruby-next/language/edge"
require "ruby-next/language/proposed"
require "ruby-next/language/bootsnap"
