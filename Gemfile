# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

ruby '2.6.3'

gem 'puma'
gem 'redis'
gem 'sinatra'

group :test do
  gem 'mock_redis'
  gem 'rspec'
  gem 'vcr'
  gem 'webmock', require: 'webmock/rspec'
end

group :development do
  gem 'byebug'
  gem 'rubocop', '~> 0.74.0', require: false
end
