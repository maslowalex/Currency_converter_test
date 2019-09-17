# frozen_string_literal: true

require 'sinatra/base'
require_relative 'storage'
require_relative 'currencies_api'

class App < Sinatra::Base
  set :public_folder, 'public'

  get '/' do
    erb :index
  end

  post '/currencies.json' do
    content_type :json

    CurrenciesApi.new(name: params['name']).call.to_json
  end

  get '/currencies/:name.json' do
    content_type :json

    Storage.new(params['name']).get_all_currencies.to_json
  end
end
