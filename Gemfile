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

gem 'anycable-thruster'

group :development, :test do
  # FIXME: Fails with Operation not supported by device - <STDIN> when running within Thruster
  gem 'debug', '~> 1.9'#, require: false
  gem 'rspec-rails', '~> 6.0'
end

group :development do
  gem 'overmind'
end

group :test do
  gem 'capybara'
  gem 'capybara-thruster'
  gem 'cuprite'

  gem 'test-prof'
end
