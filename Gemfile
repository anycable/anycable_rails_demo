source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'rails', '~> 6.1'
gem 'webpacker', '~> 4.0'
gem 'pg', '~> 1.0'
gem 'puma', '~> 4.1'
gem 'redis', '~> 4.0'
gem 'anycable-rails', '~> 1.0.0'
gem 'cable_ready', '~> 4.3.0'
gem 'stimulus_reflex', '~> 3.3.0'

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

  gem 'stimulus_reflex_testing'

  gem 'test-prof'
end
