# frozen_string_literal: true

require 'sinatra/base'
require_relative 'storage'
require_relative 'currencies_api'

class App < Sinatra::Base
  set :public_folder, 'public'

  get '/' do
    erb :index, locals: {
      last_update: Storage.new(CurrenciesApi::DEFAULT_CURRENCY).updated_at
    }
  end

  put '/currencies/:name.json' do
    content_type :json

    CurrenciesApi.new(name: params['name']).call.to_json
  end

  get '/currencies/:name.json' do
    content_type :json

    Storage.new(params['name']).get_all_currencies.to_json
  end
end
