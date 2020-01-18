source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2', '>= 6.0.2.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Active Admin is a Ruby on Rails framework for creating elegant backends for website administration.
gem 'activeadmin', '~> 2.6'

#gem 'active_leonardo', path: '/home/mark/Lavoro/Gems/ActiveLeonardo'

# Flexible authentication solution for Rails with Warden
gem 'devise', '~> 4.7.0'

# Simple, efficient background processing for Ruby
gem 'sidekiq'
gem 'sidekiq-cron'

# A simple, standardized way to build and use Service Objects (aka Commands) in Ruby
gem 'simple_command', '~> 0.0.9'

# A ruby implementation of the RFC 7519 OAuth JSON Web Token (JWT) standard.
gem 'jwt', '~> 2.2.1'

# Consuming restful web services
gem 'http'

# Parse Accept and Accept-Language HTTP headers in Ruby.
gem 'http-accept', '~> 2.1.0'

# Find out which locale the user preferes by reading the languages they specified in their browser or in the header
#gem 'http_accept_language' #, '~> 2.1.1'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # RSpec for Rails - Need to be in development for mail preview
  gem 'rspec-rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # A Ruby static code analyzer and formatter, based on the community Ruby style guide.
  gem 'rubocop'

  # A static analysis security vulnerability scanner for Ruby on Rails applications
  gem 'brakeman'

  # A code metric tool for rails projects
  gem 'rails_best_practices'

  # Great Ruby dubugging companion: pretty print Ruby objects to visualize their structure
  gem 'awesome_print'

  # Provides a better error page for Rails
  gem 'better_errors'

  # Retrieve the binding of a method's caller.
  gem 'binding_of_caller'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
