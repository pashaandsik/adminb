source 'https://rubygems.org'

gem 'rails', '4.2.6'
gem 'pg', '~> 0.15'
gem 'bootstrap-sass'
gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'draper'
gem 'nokogiri'
gem 'simple_form'
gem 'daemons-rails' #test
gem 'que'
gem 'virtus'
gem 'slim-rails'
gem 'scrypt'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'admin',    path: 'vendor/admin'

group :development, :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'spring-commands-rspec'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'yard'
  gem 'image_size'
  gem 'timecop'
end

group :test do
  gem 'webmock'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'better_errors'
  gem 'spring'
  gem 'rubocop',                  require: false, git: 'https://github.com/bbatsov/rubocop.git'
  gem 'rubocop-rspec',            require: false
end

