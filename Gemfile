source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.5'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'

# Use FontAwesome glyphicons
gem "font-awesome-rails"

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Makes turbolinks play nicely with jquery
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

group :development, :test do
  # Use sqlite3 as the database for Active Record in dev and test
  gem 'sqlite3'
  gem 'rspec-rails', '~> 3.0.0'
end

group :test do
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara',  '~> 2.2.0'
  gem 'factory_girl_rails', '4.2.1'
end

group :production do
  # Use postgres in production
  gem 'pg'

  # Application servers. Only one of these will be needed in the end (!)
  gem "puma", "3.12.3"
  #gem "passenger", ">= 5.0.25", require: "phusion_passenger/rack_handler"  
end

#ActiveRecord session store
gem 'activerecord-session_store'

# Authentication with Devise
gem 'devise'
# and Omniauth
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem "omniauth-google-oauth2"

# Resource administration with rails_admin
gem 'rails_admin', '~> 0.6.2'

# Bootstrap styling
gem 'autoprefixer-rails', '5.0.0.1'
gem 'bootstrap-sass', '3.3.3'

# Datepicker
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.7.14'

# Pagination
gem 'will_paginate', '3.0.4'

# Datatables (www.datatables.net/)
gem 'jquery-datatables-rails', '~> 2.2.1'
gem 'lodash-rails'

# File upload with Paperclip (https://github.com/thoughtbot/paperclip)
gem "paperclip", "~> 4.1"

# Age calculation
gem "adroit-age"

# Environment variables in .env
gem 'dotenv-rails'

# Needed to run on Windows
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]

# This gem splits the big application.css file into smaller pieces to get around
# the stupid IE selector limit
gem 'css_splitter'

# XML parsing
gem 'nokogiri'

# API Serializing
gem 'active_model_serializers', '0.9.3'
