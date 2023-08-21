require 'rails_helper'

RSpec.describe CurrencyService, type: :service do
  let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }

  before do
    allow(Rails).to receive(:cache).and_return(memory_store)
    Rails.cache.clear
  end

  it 'gets currency exchange rates' do
    exchange_rates = CurrencyService.exchange_rates
    expect(exchange_rates[:EUR]).to be_a_kind_of(Numeric)
    expect(exchange_rates[:INR]).to be_a_kind_of(Numeric)
    expect(exchange_rates[:USD]).to be_a_kind_of(Numeric)
  end
end
