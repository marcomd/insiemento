source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.7'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.2.3', '< 2.0'

# Use Puma as the app server
gem 'puma', '~> 6.4.3'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0.0'

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.2.5'

# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Active Admin is a Ruby on Rails framework for creating elegant backends for website administration.
gem 'activeadmin', '~> 2.14.0'

# gem 'active_leonardo', path: '/home/mark/Lavoro/Gems/ActiveLeonardo'

# Flexible authentication solution for Rails with Warden
gem 'devise', '~> 4.7.0'

# Simple, efficient background processing for Ruby
gem 'sidekiq', '~> 6.5.0'

# A scheduling add-on for Sidekiq.
gem 'sidekiq-cron', '~> 1.12.0'

# An extension to the sidekiq message processing to track your jobs
gem 'sidekiq-status', '~> 3.0.3'

# A simple, standardized way to build and use Service Objects (aka Commands) in Ruby
gem 'simple_command', github: 'nebulab/simple_command'

# A ruby implementation of the RFC 7519 OAuth JSON Web Token (JWT) standard.
gem 'jwt', '~> 2.2.2'

# Consuming restful web services
gem 'http', '~> 4.3.0'

# Parse Accept and Accept-Language HTTP headers in Ruby.
gem 'http-accept', '~> 2.1.1'

# Find out which locale the user preferes by reading the languages they specified in their browser or in the header
# gem 'http_accept_language' #, '~> 2.1.1'

# A simple HTTP and REST client for Ruby
gem 'rest-client', '~> 2.0.2'

# Pure Ruby library for Handlebars templates
gem 'ruby-handlebars', '~> 0.4.0'

# ActiveRecord::Store allows you to put data, like a hash, in a single column.
# The problem is that when you retrieve these values, they are strings. Storext aims to solve that.
# This is a layer on top of ActiveRecord::Store that uses Virtus to typecast the values
gem 'storext', '~> 3.3.0'

# This library provides integration of the money gem with Rails.
# A Ruby Library for dealing with money and currency conversion.
gem 'money-rails', '~> 1.13.4'

# Simple authorization solution for Rails. All permissions are stored in a single location.
gem 'cancancan', '~> 3.2.1'

#  Extends ActiveAdmin to enable a set of great optional UX improving add-ons
gem 'activeadmin_addons' # , '~> 1.7.0'

# Ruby state machines
gem 'aasm', '~> 5.1.1'

# This gem embeddes the jQuery colorpicker in the Rails asset pipeline.
gem 'jquery-minicolors-rails', '~> 2.2.6'

# Incorporate JQuery Minicolors into your ActiveAdmin apps.
gem 'activeadmin-minicolors', github: 'kholdrex/activeadmin-minicolors'

# Provides higher-level image processing helpers that are commonly needed when handling image uploads
# This gem can process images with either ImageMagick/GraphicsMagick or libvips libraries.
# ImageMagick is a good default choice, especially if you are migrating from another gem or library that uses ImageMagick.
# Libvips is a newer library that can process images very rapidly (often multiple times faster than ImageMagick).
gem 'image_processing', '~> 1.12.2'

# This is version 3 of the aws-sdk gem
gem 'aws-sdk-s3', require: false

# The Stripe Ruby library provides convenient access to the Stripe API
gem 'stripe', '~> 5.29.1'

# Prawn is a pure Ruby PDF generation library that provides a lot of great functionality while trying to remain simple and reasonably performant
gem 'prawn', '~> 2.4.0'

# Create beautiful JavaScript charts with one line of Ruby
gem 'chartkick', '~> 3.4.2'

# The simplest way to group by
gem 'groupdate', '~> 5.2.2'

# Required by ruby 3.1
# An implementation of Matrix and Vector classes.
gem 'matrix', '~> 0.4.2'
gem 'psych', '< 4'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 11.0.1', platforms: %i[mri mingw x64_mingw]

  # RSpec for Rails - Need to be in development for mail preview
  gem 'rspec-rails', '~> 4.0.0'

  # fixtures replacement with a straightforward definition syntax
  gem 'factory_bot', '5.1.1'
  gem 'factory_bot_rails', '~> 5.1.0'

  # Shim to load environment variables from .env into ENV in development
  gem 'dotenv-rails'

  # A Ruby static code analyzer and formatter, based on the community Ruby style guide.
  gem 'rubocop' # , '~> 0.92.0'
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.7.1'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 4.1.1'
  gem 'spring-watcher-listen', '~> 2.1.0'

  # RSpec command for spring
  gem 'spring-commands-rspec'

  # A static analysis security vulnerability scanner for Ruby on Rails applications
  gem 'brakeman', '~> 4.7.2'

  # A code metric tool for rails projects
  # gem 'rails_best_practices', '~> 1.20'

  # Great Ruby dubugging companion: pretty print Ruby objects to visualize their structure
  gem 'awesome_print', '~> 1.8.0'

  # Provides a better error page for Rails
  gem 'better_errors', '~> 2.8.0'

  # Retrieve the binding of a method's caller.
  gem 'binding_of_caller', '~> 1.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver', '~> 3.142.7'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers', '~> 4.2.0'

  # RSpec and Minitest-compatible one-liners to test common Rails functionality
  gem 'shoulda-matchers', '~> 4.3'

  # Record your test suite's HTTP interactions and replay them during future test
  gem 'vcr' # , '~> 5.1.0'

  # Library for stubbing and setting expectations on HTTP requests in Ruby.
  gem 'webmock', '~> 3.8.0'

  # SimpleCov is a code coverage analysis tool for Ruby
  gem 'simplecov', '~> 0.18.5', require: false

  # A gem providing 'time travel', 'time freezing', and 'time acceleration' capabilities, making it simple to test time-dependent code. It provides a unified method to mock Time.now, Date.today, and DateTime.now in a single call.
  gem 'timecop' # , '~> 0.9.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
