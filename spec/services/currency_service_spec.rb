require 'rails_helper'
require 'webmock/rspec'

RSpec.describe CurrencyService, type: :service do
  let(:base_uri) { 'http://api.apilayer.com/fixer/latest?base=INR&symbols=INR,USD,EUR' }
  let(:headers) { { 'apikey' => Rails.application.credentials.fixer['api_key'] } }

  let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }

  before do
    allow(Rails).to receive(:cache).and_return(memory_store)
    Rails.cache.clear
  end

  xcontext 'when API request fails' do
    before do
      stub_request(:get, base_uri).with(headers:).to_return(body: nil, status: 429)
    end

    it 'should return nil' do
      expect(CurrencyService.exchange_rates).to be_nil
    end
  end

  context 'when API request is successful' do
    let(:response_body) { '{ "rates": { "EUR": 0.011076, "INR": 1, "USD": 0.012029 } }' }

    before do
      stub_request(:get, base_uri).with(headers:).to_return(body: response_body, status: 200)
    end

    it 'gets currency exchange rates' do
      exchange_rates = CurrencyService.exchange_rates
      expect(exchange_rates['EUR']).to be_a_kind_of(Numeric)
      expect(exchange_rates['INR']).to be_a_kind_of(Numeric)
      expect(exchange_rates['USD']).to be_a_kind_of(Numeric)
    end
  end
end
