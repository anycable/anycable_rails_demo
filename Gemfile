source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.2.0'

gem 'rails', '~> 7.1.0'
gem 'sqlite3', '~> 1.4'
gem 'puma', '~> 6.0'
gem 'redis', '~> 5.0'
gem 'grpc', '~> 1.37'
gem 'anycable-rails', '~> 1.5'
gem 'daemons', '~> 1.3', require: false

gem 'bootsnap', '>= 1.4.2', require: false
gem 'ruby-next', '~> 1.0', require: false

gem 'nanoid'
gem 'turbo-rails'

gem 'cssbundling-rails'
gem 'jsbundling-rails'
gem 'propshaft'

group :development, :test do
  gem 'debug', '~> 1.9'
  gem 'rspec-rails', '~> 6.0'
end

group :development do
end

group :test do
  gem 'capybara'
  gem 'cuprite'

  # Rack-based AnyCable server implementation
  gem 'anycable-rack-server', '~> 0.5'

  gem 'test-prof'
end
