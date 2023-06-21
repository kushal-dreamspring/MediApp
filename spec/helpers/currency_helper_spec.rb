require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the AppointmentsHelper. For example:
#
# describe AppointmentsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe CurrencyHelper, type: :helper do
  it "gets currency exchange rates" do
    exchange_rates = CurrencyHelper.exchange_rates
    expect(exchange_rates["EUR"]).to be_a_kind_of(Numeric)
    expect(exchange_rates["USD"]).to be_a_kind_of(Numeric)
  end
end
