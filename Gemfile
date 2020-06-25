source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.1'

gem 'rails', '~> 6.1'
gem 'webpacker', '6.0.0.beta.6'
gem 'sqlite3', '~> 1.4'
gem 'puma', '~> 4.1'
gem 'anycable', '> 1.0.99'
gem 'anycable-rails', '> 1.0.99'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'ruby-next', '>= 0.10.0', require: false

gem 'nanoid'
gem 'turbo-rails'

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 4.0.0'
end

group :development do
  gem 'listen'

  gem "standard", "~> 1.0"
  gem "rubocop-rspec"
  gem "rubocop-rails"
end

group :test do
  gem 'capybara'
  gem 'cuprite'

  # Rack-based AnyCable server implementation
  gem 'anycable-rack-server', '~> 0.3.0'

  gem 'test-prof'
end
