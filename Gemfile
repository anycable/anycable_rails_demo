source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.2.0'

gem 'rails', '~> 7.1.0'
# gem 'pg', '~> 1.0'
gem 'sqlite3'
gem 'puma', '~> 6.0'
gem 'anycable-rails-core', '1.5.0.rc.1', require: ['anycable-rails']
gem 'google-protobuf', '~> 3.25'
gem 'daemons', '~> 1.3', require: false

gem 'bootsnap', '>= 1.4.2', require: false
gem 'ruby-next', '>= 0.15.0', require: false

gem 'nanoid'
gem 'turbo-rails'

gem 'cssbundling-rails'
gem 'jsbundling-rails'
gem 'propshaft'

group :wasm do
  # Use nulldb as the database for Active Record
  gem "activerecord-nulldb-adapter"

  # Time zone info for ActiveSupport
  gem "tzinfo-data"

  # Building
  gem "ruby_wasm", "~> 2.5"
end

gem "js", group: :js

group :development, :test do
  gem 'debug', '1.7.0'
  gem 'rspec-rails', '~> 6.0'
end

group :development do
end

group :test do
  gem 'capybara'
  gem 'cuprite'

  gem 'test-prof'
end
