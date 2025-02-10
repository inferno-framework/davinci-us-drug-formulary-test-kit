# frozen_string_literal: true

source "https://rubygems.org"

gemspec

group :development, :test do
  gem 'debug'

  gem "rubocop", "~> 1.56"
  gem 'rubocop-rspec', require: false
  gem "rubocop-rake", "~> 0.6.0"
end

group :test do
  gem 'simplecov', require: false
  gem 'simplecov-cobertura'

  gem 'rack-test'
end
