require 'rails_helper'

RSpec.describe "appointments/index", type: :view do
  fixtures :doctors, :users

  before(:each) do
    assign(:appointments, [
      Appointment.create!(
        doctor: doctors(:one),
        user: users(:zero),
        date_time: DateTime.now
      ),
      Appointment.create!(
        doctor: doctors(:two),
        user: users(:zero),
        date_time: DateTime.now
      )
    ])
  end

  it "renders a list of appointments" do
    render
    cell_selector = '#appointment_1'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 1
  end
end
