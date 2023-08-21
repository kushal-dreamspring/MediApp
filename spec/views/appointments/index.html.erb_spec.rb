require 'rails_helper'

RSpec.describe "appointments/index", type: :view do
  fixtures :doctors, :users

  before(:each) do
    assign(:appointments, [
             Appointment.create!(
               doctor: doctors(:one),
               user: users(:one),
               date_time: DateTime.now + 1.hour,
               amount: 500,
               conversion_rates: { "EUR": 0.011076, "INR": 1, "USD": 0.012029 }
             ),
             Appointment.create!(
               doctor: doctors(:two),
               user: users(:one),
               date_time: DateTime.now + 2.hour,
               amount: 500,
               conversion_rates: { "EUR": 0.011076, "INR": 1, "USD": 0.012029 }
             )
           ])
  end

  it "renders a list of appointments" do
    render
    cell_selector = '#appointment_1'
    assert_select cell_selector, text: /#{doctors(:two).name}/, count: 0
  end
end
