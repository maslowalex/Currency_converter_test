# frozen_string_literal: true

require 'spec_helper'

describe App do
  let(:app) { App.new }

  context 'GET root' do
    let(:response) { get '/' }

    it 'returns status 200' do
      expect(response.status).to eq 200
    end
  end

  context 'POST currencies' do
    before do
      Storage.new.remove_currencies
    end

    let(:response) { post '/currencies.json' }

    it 'updates currencies rates and return it as json' do
      VCR.use_cassette('currencies/refresh') do
        json = JSON.parse(response.body)
        storage = Storage.new

        expect(response.status).to eq 200
        expect(json.keys).to contain_exactly('rates', 'base', 'date')
        expect(storage.get_all_currencies.size).to eq 33
      end
    end
  end

  context 'GET currencies' do
    let(:response) { get '/currencies.json' }

    it 'returns currencies json' do
      json = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(json.keys).to contain_exactly('currencies')
      expect(json.fetch('currencies').size).to eq 33
    end
  end
end
