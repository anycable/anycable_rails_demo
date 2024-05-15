source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.2.0'

if File.directory?('../../rails')
  path '../../rails' do
    # We need to enumerate all Rails gems to avoid updating the Gemfile.lock
    # when using a local copy of Rails
    gem 'activesupport'
    gem 'actioncable'
    gem 'actionview'
    gem 'actionpack'
    gem 'actionmailer'
    gem 'activemodel'
    gem 'activerecord'
    gem 'actiontext'
    gem 'actionmailbox'
    gem 'activejob'
    gem 'activestorage'
    gem 'railties'
    gem 'rails'
  end
else
  gem 'rails', github: 'palkan/rails', branch: 'refactor/action-cable-server-adapterization'
end

gem 'sqlite3', '~> 1.4'
gem 'iodine'
gem 'redis', '~> 5.0'
gem 'grpc', '~> 1.37'
gem 'anycable-rails', '~> 1.5', require: false
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
  gem 'overmind'
end

group :test do
  gem 'capybara'
  gem 'cuprite'

  # Rack-based AnyCable server implementation
  gem 'anycable-rack-server', '~> 0.5'

  gem 'test-prof'
end
