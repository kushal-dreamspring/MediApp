# frozen_string_literal: true

require "uri"
require "net/http"

module CurrencyHelper
  def self.amount_in_currency(amount, currency)
    return amount if(currency == 'INR')

    amount * exchange_rates[currency]
  end

  def self.exchange_rates
    Rails.cache.write(Date.today.strftime('%Y-%m-%d'), { 'EUR' => 0.011076, 'INR' => 1, 'USD' => 0.012029 })

    cached_exchange_rate =  Rails.cache.fetch(Date.today.strftime('%Y-%m-%d'))

    return cached_exchange_rate unless cached_exchange_rate.nil?

    url = URI("http://api.apilayer.com/fixer/latest?base=INR&symbols=USD,EUR")

    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url)
    request["apikey"] = Rails.application.credentials.fixer['api_key']

    response = JSON.parse(http.request(request).body)

    Rails.cache.write(Date.today.strftime('%Y-%m-%d'), response["rates"])

    response["rates"]
  end
end
