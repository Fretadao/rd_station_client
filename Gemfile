# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in rd_station_client.gemspec
gemspec

group :development do
  gem 'f_http_client', github: 'Fretadao/f_http_client', branch: 'bv-improve-gem-extendability'
  gem 'f_service', github: 'Fretadao/f_service', branch: 'master'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rspec'
end

group :test do
  gem 'rspec', '~> 3.0'
  gem 'simplecov'
  gem 'webmock'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rake', '~> 13.0'
end
