source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'rails', '~> 6.0.2', '>= 6.0.2.2'
gem 'webpacker', '~> 4.0'
gem 'pg', '~> 1.0'
gem 'puma', '~> 4.1'
gem 'redis', '~> 4.0'
gem 'anycable-rails', '~> 1.0.0'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'ruby-next', '>= 0.10.0', require: false

gem 'nanoid'
# We only need controllers integration
gem 'turbolinks', require: 'turbolinks/redirection'

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 4.0.0'
end

group :development do
  gem 'listen'

  gem "standard", "~> 0.2.0"
  gem "rubocop-rspec"
  gem "rubocop-rails"
end

group :test do
  gem 'capybara'
  # Rails system tests couldn't run without it, event though we don't use it
  # https://github.com/rails/rails/pull/39179
  gem 'selenium-webdriver'
  gem 'cuprite'

  gem 'test-prof'
end
