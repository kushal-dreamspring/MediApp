# frozen_string_literal: true

require 'uri'
require 'net/http'

module CurrencyService
  def self.exchange_rates
    Rails.cache.write(Date.today.strftime('%Y-%m-%d'), { "EUR": 0.011076, "INR": 1, "USD": 0.012029 })

    Rails.cache.fetch(Date.current.strftime('%Y-%m-%d')) do
      url = URI("http://api.apilayer.com/fixer/latest?base=INR&symbols=INR,USD,EUR")

      http = Net::HTTP.new(url.host, url.port)
      request = Net::HTTP::Get.new(url)
      request['apikey'] = Rails.application.credentials.fixer['api_key']

      JSON.parse(http.request(request).body)['rates']
    end
  end
end
