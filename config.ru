# frozen_string_literal: true

# \ -s Puma
require 'rubygems'
require 'bundler'

Bundler.require

require './lib/app'

run App
