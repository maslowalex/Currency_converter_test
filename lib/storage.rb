# frozen_string_literal: true

require 'redis'
require_relative 'currencies_api'

class Storage
  RATES = 'rates'

  def initialize(name)
    @redis = redis_client
    @name = name.upcase
  end

  def save_currencies(currencies)
    return true if updated_today?

    currencies.each do |currency, rate|
      @redis.hset(key_by_name, currency, rate)
    end

    save_timestamp
  end

  def key_by_name
    "#{@name}_#{RATES}"
  end

  def get_all_currencies
    rates_from_db = @redis.hgetall(key_by_name)

    rates_from_db.empty? ? CurrenciesApi.new(name: @name).call : { 'currencies' => rates_from_db }
  end

  def remove_currencies
    @redis.del(key_by_name)
    @redis.del("#{@name}_rates_updated_at")
  end

  def updated_today?
    Time.now.strftime('%Y-%m-%d') == @redis.get("#{@name}_rates_updated_at")
  end

  def updated_at
    @redis.get("#{@name}_rates_updated_at")
  end

  private

  def save_timestamp
    @redis.set("#{@name}_rates_updated_at", Time.now.strftime('%Y-%m-%d'))
  end

  def redis_client
    case ENV['APP']
    when 'production'
      Redis.new(url: ENV['REDIS_URL'])
    else
      Redis.new
    end
  end
end
