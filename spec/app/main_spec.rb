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

  before(:each) do
    Storage.new('PLN').remove_currencies
  end

  context 'POST currencies' do
    let(:response) { post '/currencies.json', { 'name' => 'PLN' } }

    it 'updates currencies rates and return it as json' do
      VCR.use_cassette('currencies/refresh') do
        json = JSON.parse(response.body)
        storage = Storage.new('PLN')

        expect(response.status).to eq 200
        expect(json.keys).to contain_exactly('currencies')
        expect(storage.get_all_currencies.fetch('currencies').size).to eq 33
        expect(storage.updated_today?).to eq true
      end
    end
  end

  context 'GET currencies' do
    context 'with valid params' do
      let(:response) { get '/currencies/PLN.json' }

      it 'returns currencies json' do
        VCR.use_cassette('currencies/get_pln') do 
          json = JSON.parse(response.body)
    
          expect(response.status).to eq 200
          expect(json.keys).to contain_exactly('currencies')
          expect(json.fetch('currencies').size).to eq 33
        end
      end
    end

    context 'with invalid params' do
      let(:response) { get '/currencies/blah.json' }

      it 'returns an error' do
        VCR.use_cassette('currencies/invalid_name') do
          json = JSON.parse(response.body)
          
          expect(response.status).to eq 200
          expect(json.keys).to contain_exactly('error')
          expect(json.fetch('error')).to eq "Base 'BLAH' is not supported."
        end
      end
    end
  end
end

