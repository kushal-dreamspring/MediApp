require "uri"
require "net/http"

module CurrencyService
  def self.amount_in_currency(amount, currency)
    amount * exchange_rates[currency]
  end

  private

  def self.exchange_rates

    cached_exchange_rate =  Rails.cache.fetch(Date.today.strftime('%Y-%m-%d'))

    return cached_exchange_rate unless cached_exchange_rate.nil?

    url = URI("http://api.apilayer.com/fixer/latest?base=INR&symbols=USD,EUR")

    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url)
    request["apikey"] = "9m1oj1orczTovgp23TUaNXPZF4zWHfyd"

    response = JSON.parse(http.request(request).body)

    Rails.cache.write(Date.today.strftime('%Y-%m-%d'), response["rates"])

    response["rates"]
  end
end
