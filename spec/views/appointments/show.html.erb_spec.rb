require 'rails_helper'

RSpec.describe "appointments/show", type: :view do
  before(:each) do
    assign(:appointment, Appointment.create!(
      doctor: nil,
      user: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
