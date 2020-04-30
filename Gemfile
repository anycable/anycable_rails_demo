source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'rails', '~> 6.0.2', '>= 6.0.2.2'
gem 'webpacker', '~> 4.0'
gem 'pg', '~> 1.0'
gem 'puma', '~> 4.1'
gem 'redis', '~> 4.0'

gem 'bootsnap', '>= 1.4.2', require: false

gem 'nanoid'

group :development, :test do
  gem 'pry-byebug', platforms: [:mri]
end

group :development do
  gem 'listen'

  gem "standard", "~> 0.2.0"
end
