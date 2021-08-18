source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.1'

gem 'rails', '~> 6.1'
gem 'webpacker', '6.0.0.beta.6'
gem 'pg', '~> 1.0'
gem 'puma', '~> 4.1'
gem 'redis', '~> 4.0'
gem 'grpc', '~> 1.37'
gem 'anycable-rails', '~> 1.1.0'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'ruby-next', '>= 0.10.0', require: false

gem 'nanoid'
gem 'turbo-rails'

gem "yabeda-anycable"
gem "yabeda-rails"
gem "yabeda-puma-plugin"
gem "yabeda-prometheus"
gem "webrick" # For exporting metrics from AnyCable RPC

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

  gem 'test-prof'
end
