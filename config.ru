# frozen_string_literal: true

# \ -s Puma
require 'rubygems'
require 'bundler'

Bundler.require

require './lib/app'
$redis = ENV['APP'] == 'production' ? Redis.new(url: ENV['REDIS_URL']) : Redis.new

run App
