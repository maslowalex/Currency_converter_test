# frozen_string_literal: true

require 'net/http'
require 'json'
require_relative 'storage'

class CurrenciesApi
  BASE_URL = 'https://api.exchangeratesapi.io'
  ENDPOINT = 'latest'
  QUERY = %w[base USD].freeze
  CURRENCIES_PATH = 'rates'

  def call
    @response = make_request!

    if @response.code.to_i == 200
      save_rates_to_db
      json_response
    else
      error
    end
  end

  private

  def json_response
    JSON.parse(@response.body)
  end

  def make_request!
    url = URI(compose_url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    http.request(request)
  end

  def compose_url
    BASE_URL + '/' + ENDPOINT + '?' + QUERY.join('=')
  end

  def error
    { 'error' => json_response }
  end

  def save_rates_to_db
    Storage.new.save_currencies(json_response.fetch(CURRENCIES_PATH))
  end
end
