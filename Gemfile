source 'http://rubygems.org'

if ENV["JRUBY"] == "1" || ENV["RACK_ENV"] == "production" || ENV["RACK_ENV"] == "test"
  ruby '2.2.2', engine: 'jruby', engine_version: '9.0.4.0'
  gem 'pg', '0.17.1', :platform => :jruby, :github => 'headius/jruby-pg'
else
  ruby '2.2.4'
  gem 'pg'
end

gem 'rails', '4.2.5'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'puma'
gem 'date_validator'
gem 'validate_url'
gem 'typhoeus'
gem 'nokogiri'
gem 'friendly_id'
gem 'bootstrap-sass'
gem 'rgeo-activerecord'
gem 'dotenv-rails'
gem 'browserify-rails'
gem 'rgeo-geojson'
gem 'will_paginate'
gem 'geokit-rails'
gem 'tabula-extractor', platform: :jruby, require: "tabula"
gem 'dalli'
gem 'dc_address_lookup'
gem 'pdftotext'
gem 'connection_pool'
gem 'actionpack-action_caching'
gem 'mechanize'

group :development do
  gem 'pry'
end

group :production do
  gem 'rails_12factor'
end

group :test do
  gem 'webmock'
end
