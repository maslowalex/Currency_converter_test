# frozen_string_literal: true

require 'redis'

class Storage
  CURRENCIES = 'currencies'

  def initialize
    @redis = redis_client
  end

  def save_currencies(currencies)
    return true if updated_today?

    currencies.each do |currency, rate|
      @redis.hset(CURRENCIES, currency, rate)
    end

    save_timestamp
  end

  def get_all_currencies
    @redis.hgetall(CURRENCIES)
  end

  def remove_currencies
    @redis.del(CURRENCIES)
    @redis.del('currencies_updated_at')
  end

  def updated_today?
    Time.now.strftime('%Y-%m-%d') == @redis.get('currencies_updated_at')
  end

  private

  def save_timestamp
    @redis.set('currencies_updated_at', Time.now.strftime('%Y-%m-%d'))
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
