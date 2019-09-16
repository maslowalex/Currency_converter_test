# frozen_string_literal: true

require 'sinatra/base'
require 'json'
require_relative 'storage'
require_relative 'currencies_api'

class App < Sinatra::Base
  get '/' do
  end

  post '/currencies.json' do
    content_type :json

    CurrenciesApi.new.call.to_json
  end

  get '/currencies.json' do
    content_type :json

    { 'currencies' => Storage.new.get_all_currencies }.to_json
  end
end
